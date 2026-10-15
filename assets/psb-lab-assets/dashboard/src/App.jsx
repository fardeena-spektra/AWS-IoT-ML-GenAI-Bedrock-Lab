import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { AuthError, askAssistant, getAnomalies, getTelemetry } from './api.js';

const TOKEN_KEY = 'psb_id_token';
const RELOGIN_KEY = 'psb_relogin_at';
const REFRESH_MS = 30000;
let redirecting = false; // avoids a double redirect (React StrictMode runs effects twice in dev)

const METRICS = [
  { id: 'temperature_c', label: 'Temperature', unit: '°C', digits: 2 },
  { id: 'humidity_pct', label: 'Humidity', unit: '%', digits: 1 },
  { id: 'co2_ppm', label: 'CO₂', unit: 'ppm', digits: 0 },
  { id: 'vibration_g', label: 'Vibration', unit: 'g', digits: 3 },
  { id: 'anomaly_score', label: 'Anomaly score', unit: '', digits: 3 },
];
const WINDOWS = [
  { minutes: 15, label: '15m' },
  { minutes: 60, label: '1h' },
  { minutes: 360, label: '6h' },
  { minutes: 1440, label: '24h' },
];
const LOCATIONS = ['north-lab', 'south-lab', 'server-room'];
const LOCATION_COLORS = { 'north-lab': '#2563eb', 'south-lab': '#0d9488', 'server-room': '#9333ea' };

// ------------------------------------------------------------------ auth
function decodeJwt(token) {
  try {
    const part = token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/');
    const json = decodeURIComponent(
      atob(part.padEnd(part.length + ((4 - (part.length % 4)) % 4), '='))
        .split('')
        .map((c) => '%' + c.charCodeAt(0).toString(16).padStart(2, '0'))
        .join('')
    );
    return JSON.parse(json);
  } catch {
    return null;
  }
}

function tokenValid(token) {
  const claims = token && decodeJwt(token);
  return !!claims && typeof claims.exp === 'number' && claims.exp * 1000 > Date.now() + 30000;
}

function isConfigured(config) {
  return ![config.cognitoDomain, config.userPoolClientId, config.apiBaseUrl].some((v) => !v || v.includes('<'));
}

/**
 * useAuth: after the Cognito Hosted UI redirect, reads id_token from location.hash,
 * stores it in sessionStorage 'psb_id_token', checks exp, and redirects to the
 * Hosted UI login page when the token is missing or expired.
 */
function useAuth(config) {
  const redirectUri = `${window.location.origin}/`;
  const [token, setToken] = useState(() => {
    const hash = new URLSearchParams(window.location.hash.replace(/^#/, ''));
    const fromHash = hash.get('id_token');
    if (fromHash) {
      sessionStorage.setItem(TOKEN_KEY, fromHash);
      window.history.replaceState(null, '', window.location.pathname + window.location.search);
    }
    const stored = sessionStorage.getItem(TOKEN_KEY);
    return tokenValid(stored) ? stored : null;
  });
  const [loopError, setLoopError] = useState(false);

  const login = useCallback(() => {
    if (redirecting) return;
    // Guard against a redirect loop (e.g. wrong authorizer audience returns 401 for every token).
    const last = Number(sessionStorage.getItem(RELOGIN_KEY) || 0);
    if (Date.now() - last < 20000) {
      setLoopError(true);
      return;
    }
    sessionStorage.setItem(RELOGIN_KEY, String(Date.now()));
    redirecting = true;
    const qs =
      `client_id=${encodeURIComponent(config.userPoolClientId)}` +
      `&response_type=token&scope=email+openid+profile&redirect_uri=${encodeURIComponent(redirectUri)}`;
    window.location.assign(`${config.cognitoDomain}/login?${qs}`);
  }, [config, redirectUri]);

  const logout = useCallback(() => {
    sessionStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(RELOGIN_KEY);
    const qs = `client_id=${encodeURIComponent(config.userPoolClientId)}&logout_uri=${encodeURIComponent(redirectUri)}`;
    window.location.assign(`${config.cognitoDomain}/logout?${qs}`);
  }, [config, redirectUri]);

  const reLogin = useCallback(() => {
    sessionStorage.removeItem(TOKEN_KEY);
    setToken(null);
  }, []);

  useEffect(() => {
    if (!token && isConfigured(config)) login();
  }, [token, config, login]);

  const claims = token ? decodeJwt(token) : null;
  return { token, email: claims?.email || claims?.['cognito:username'] || '', login, logout, reLogin, loopError };
}

// ------------------------------------------------------------------ helpers
function fmt(v, digits) {
  return v === null || v === undefined || Number.isNaN(v) ? '–' : Number(v).toFixed(digits);
}

function summarize(values) {
  if (!values.length) return { count: 0, min: null, max: null, mean: null, latest: null };
  const sum = values.reduce((a, b) => a + b, 0);
  return { count: values.length, min: Math.min(...values), max: Math.max(...values), mean: sum / values.length, latest: values[values.length - 1] };
}

function timeLabel(ms, windowMinutes) {
  const d = new Date(ms);
  const hm = d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  return windowMinutes > 720 ? `${d.toLocaleDateString([], { month: 'short', day: 'numeric' })} ${hm}` : hm;
}

// ------------------------------------------------------------------ chart (inline SVG)
function LineChart({ points, color, metric, windowMinutes }) {
  const [hover, setHover] = useState(null);
  const W = 640, H = 220, P = { l: 52, r: 16, t: 14, b: 28 };
  const data = points.map((p) => ({ ...p, t: Date.parse(p.time) })).filter((p) => !Number.isNaN(p.t));

  if (data.length === 0) {
    return <div className="chart-empty">No data in this window yet.</div>;
  }
  const tMin = Math.min(...data.map((d) => d.t));
  const tMax = Math.max(...data.map((d) => d.t));
  let vMin = Math.min(...data.map((d) => d.value));
  let vMax = Math.max(...data.map((d) => d.value));
  if (vMin === vMax) { vMin -= 1; vMax += 1; }
  const pad = (vMax - vMin) * 0.1;
  vMin -= pad; vMax += pad;
  const x = (t) => P.l + (tMax === tMin ? (W - P.l - P.r) / 2 : ((t - tMin) / (tMax - tMin)) * (W - P.l - P.r));
  const y = (v) => P.t + (1 - (v - vMin) / (vMax - vMin)) * (H - P.t - P.b);
  const path = data.map((d, i) => `${i ? 'L' : 'M'}${x(d.t).toFixed(1)},${y(d.value).toFixed(1)}`).join(' ');
  const yTicks = [0, 1, 2, 3].map((i) => vMin + ((vMax - vMin) * i) / 3);
  const xTicks = [0, 1, 2, 3].map((i) => tMin + ((tMax - tMin) * i) / 3);

  const onMove = (e) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const mx = ((e.clientX - rect.left) / rect.width) * W;
    let best = data[0];
    for (const d of data) if (Math.abs(x(d.t) - mx) < Math.abs(x(best.t) - mx)) best = d;
    setHover(best);
  };

  return (
    <svg className="chart" viewBox={`0 0 ${W} ${H}`} onMouseMove={onMove} onMouseLeave={() => setHover(null)} role="img">
      {yTicks.map((v, i) => (
        <g key={`y${i}`}>
          <line x1={P.l} x2={W - P.r} y1={y(v)} y2={y(v)} className="grid" />
          <text x={P.l - 8} y={y(v) + 4} className="axis" textAnchor="end">{fmt(v, metric.digits)}</text>
        </g>
      ))}
      {xTicks.map((t, i) => (
        <text key={`x${i}`} x={x(t)} y={H - 8} className="axis" textAnchor={i === 0 ? 'start' : i === 3 ? 'end' : 'middle'}>
          {timeLabel(t, windowMinutes)}
        </text>
      ))}
      <path d={path} fill="none" stroke={color} strokeWidth="2" strokeLinejoin="round" strokeLinecap="round" />
      {data.filter((d) => d.flagged).map((d, i) => (
        <circle key={`f${i}`} cx={x(d.t)} cy={y(d.value)} r="4" className="flag-dot" />
      ))}
      {hover && (
        <g>
          <line x1={x(hover.t)} x2={x(hover.t)} y1={P.t} y2={H - P.b} className="hover-line" />
          <circle cx={x(hover.t)} cy={y(hover.value)} r="4" fill={color} />
          <text x={Math.min(x(hover.t) + 8, W - 150)} y={P.t + 12} className="hover-text">
            {timeLabel(hover.t, 0)}  {fmt(hover.value, metric.digits)} {metric.unit}
          </text>
        </g>
      )}
    </svg>
  );
}

// ------------------------------------------------------------------ chat
function ChatPanel({ token, onAuthError }) {
  const [messages, setMessages] = useState([
    { role: 'assistant', text: 'Ask me about north-lab, south-lab or server-room, for example: "What was the average temperature in the server-room over the last hour?"' },
  ]);
  const [input, setInput] = useState('');
  const [busy, setBusy] = useState(false);
  const endRef = useRef(null);
  useEffect(() => endRef.current?.scrollIntoView({ behavior: 'smooth' }), [messages]);

  const send = async (e) => {
    e.preventDefault();
    const q = input.trim();
    if (!q || busy) return;
    setInput('');
    setMessages((m) => [...m, { role: 'user', text: q }]);
    setBusy(true);
    try {
      const res = await askAssistant(token, q);
      setMessages((m) => [...m, { role: 'assistant', text: res.answer, meta: `${res.tool_calls} tool call(s)` }]);
    } catch (err) {
      if (err instanceof AuthError) return onAuthError();
      setMessages((m) => [...m, { role: 'assistant', text: `Error: ${err.message}`, error: true }]);
    } finally {
      setBusy(false);
    }
  };

  return (
    <section className="card chat">
      <h2>Sensor assistant</h2>
      <div className="chat-log">
        {messages.map((m, i) => (
          <div key={i} className={`bubble ${m.role}${m.error ? ' error' : ''}`}>
            {m.text}
            {m.meta && <span className="meta">{m.meta}</span>}
          </div>
        ))}
        {busy && <div className="bubble assistant typing">Thinking…</div>}
        <div ref={endRef} />
      </div>
      <form className="chat-input" onSubmit={send}>
        <input value={input} onChange={(e) => setInput(e.target.value)} placeholder="Ask a question about the lab sensors" maxLength={1000} />
        <button type="submit" disabled={busy || !input.trim()}>Send</button>
      </form>
    </section>
  );
}

// ------------------------------------------------------------------ app
export default function App({ config }) {
  const auth = useAuth(config);
  const [metricId, setMetricId] = useState('temperature_c');
  const [windowMinutes, setWindowMinutes] = useState(60);
  const [location, setLocation] = useState('');
  const [points, setPoints] = useState([]);
  const [anomalies, setAnomalies] = useState({ points: [], flagged_count: 0 });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [updated, setUpdated] = useState(null);
  const metric = METRICS.find((m) => m.id === metricId);

  const load = useCallback(async () => {
    if (!auth.token) return;
    setLoading(true);
    try {
      const params = { metric: metricId, windowMinutes, location };
      const anomalyRes = await getAnomalies(auth.token, params).catch((e) => {
        if (e instanceof AuthError) throw e;
        return { points: [], flagged_count: 0, error: e.message };
      });
      if (metricId === 'anomaly_score') {
        if (anomalyRes.error) throw new Error(anomalyRes.error);
        setPoints(anomalyRes.points.map((p) => ({ time: p.time, location: p.location, value: p.anomaly_score, flagged: p.flagged })));
      } else {
        const tel = await getTelemetry(auth.token, params);
        setPoints(tel.points || []);
      }
      setAnomalies(anomalyRes);
      setError('');
      setUpdated(new Date());
    } catch (err) {
      if (err instanceof AuthError) {
        auth.reLogin();
        return;
      }
      setError(err.message || String(err));
    } finally {
      setLoading(false);
    }
  }, [auth.token, auth.reLogin, metricId, windowMinutes, location]);

  useEffect(() => {
    load();
    const id = setInterval(load, REFRESH_MS);
    return () => clearInterval(id);
  }, [load]);

  const byLocation = useMemo(() => {
    const groups = {};
    for (const loc of location ? [location] : LOCATIONS) groups[loc] = [];
    for (const p of points) if (groups[p.location]) groups[p.location].push(p);
    for (const loc of Object.keys(groups)) groups[loc].sort((a, b) => Date.parse(a.time) - Date.parse(b.time));
    return groups;
  }, [points, location]);

  const summary = useMemo(() => {
    const sorted = [...points].sort((a, b) => Date.parse(a.time) - Date.parse(b.time));
    return summarize(sorted.map((p) => p.value));
  }, [points]);

  if (!isConfigured(config)) {
    return (
      <div className="center-msg card">
        <h1>PSB Lab Dashboard</h1>
        <p>Settings are not filled in yet. Edit <code>src/config.js</code> (or <code>config.json</code> in dist.zip) with your Cognito and API values, then rebuild.</p>
      </div>
    );
  }
  if (auth.loopError) {
    return (
      <div className="center-msg card">
        <h1>Sign-in problem</h1>
        <p>The API keeps rejecting the sign-in token (HTTP 401). Check the JWT authorizer issuer and audience (client ID), then try again.</p>
        <button onClick={() => { sessionStorage.removeItem(RELOGIN_KEY); auth.login(); }}>Sign in again</button>
      </div>
    );
  }
  if (!auth.token) return <div className="center-msg">Redirecting to sign in…</div>;

  const flaggedRows = [...(anomalies.points || [])].filter((p) => p.flagged).reverse().slice(0, 50);

  return (
    <div className="app">
      <header className="topbar">
        <div className="brand">
          <span className="logo">◉</span>
          <div>
            <h1>PSB Lab Sensors</h1>
            <span className="sub">psb-lab-sensor-01 · {config.region}</span>
          </div>
        </div>
        <div className="user">
          <span className="email">{auth.email}</span>
          <button className="ghost" onClick={auth.logout}>Sign out</button>
        </div>
      </header>

      <main>
        <section className="controls card">
          <label>
            Metric
            <select value={metricId} onChange={(e) => setMetricId(e.target.value)}>
              {METRICS.map((m) => (
                <option key={m.id} value={m.id}>{m.label}{m.unit ? ` (${m.unit})` : ''}</option>
              ))}
            </select>
          </label>
          <div className="seg" role="group" aria-label="Time window">
            {WINDOWS.map((w) => (
              <button key={w.minutes} className={w.minutes === windowMinutes ? 'active' : ''} onClick={() => setWindowMinutes(w.minutes)}>
                {w.label}
              </button>
            ))}
          </div>
          <label>
            Location
            <select value={location} onChange={(e) => setLocation(e.target.value)}>
              <option value="">All</option>
              {LOCATIONS.map((l) => <option key={l} value={l}>{l}</option>)}
            </select>
          </label>
          <div className="status">
            {loading ? 'Refreshing…' : updated ? `Updated ${updated.toLocaleTimeString()}` : ''}
            <button className="ghost" onClick={load} disabled={loading}>Refresh</button>
          </div>
        </section>

        {error && <div className="alert">⚠ {error}</div>}

        <section className="summary">
          {[['Latest', summary.latest], ['Min', summary.min], ['Max', summary.max], ['Mean', summary.mean]].map(([k, v]) => (
            <div className="stat card" key={k}>
              <span className="k">{k}</span>
              <span className="v">{fmt(v, metric.digits)}<small>{metric.unit}</small></span>
            </div>
          ))}
          <div className="stat card">
            <span className="k">Flagged anomalies</span>
            <span className="v warn">{anomalies.flagged_count ?? 0}</span>
          </div>
        </section>

        <section className="charts">
          {Object.entries(byLocation).map(([loc, pts]) => (
            <div className="card chart-card" key={loc}>
              <div className="chart-head">
                <span className="dot" style={{ background: LOCATION_COLORS[loc] }} />
                <h3>{loc}</h3>
                <span className="muted">{metric.label} · {pts.length} points</span>
              </div>
              <LineChart points={pts} color={LOCATION_COLORS[loc]} metric={metric} windowMinutes={windowMinutes} />
            </div>
          ))}
        </section>

        <div className={config.assistantEnabled ? 'bottom two' : 'bottom'}>
          <section className="card">
            <h2>Anomalies <span className="muted">(flagged by the SageMaker model, last {WINDOWS.find((w) => w.minutes === windowMinutes)?.label})</span></h2>
            {flaggedRows.length === 0 ? (
              <p className="muted">No flagged readings in this window.</p>
            ) : (
              <div className="table-wrap">
                <table>
                  <thead>
                    <tr><th>Time</th><th>Location</th><th>Score</th><th>Temp °C</th><th>Hum %</th><th>CO₂ ppm</th><th>Vib g</th></tr>
                  </thead>
                  <tbody>
                    {flaggedRows.map((p, i) => (
                      <tr key={i}>
                        <td>{new Date(p.time).toLocaleString()}</td>
                        <td>{p.location}</td>
                        <td className="warn">{fmt(p.anomaly_score, 3)}</td>
                        <td>{fmt(p.temperature_c, 2)}</td>
                        <td>{fmt(p.humidity_pct, 1)}</td>
                        <td>{fmt(p.co2_ppm, 0)}</td>
                        <td>{fmt(p.vibration_g, 3)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </section>
          {config.assistantEnabled && <ChatPanel token={auth.token} onAuthError={auth.reLogin} />}
        </div>
      </main>
      <footer>Auto refresh every 30 s · AWS Demo || Bedrock with Claude</footer>
    </div>
  );
}
