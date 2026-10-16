// PSB Academy CloudLab - React dashboard.
// Settings come from src/config.js (the pre-built dist.zip also reads /config.json).
import { useCallback, useEffect, useMemo, useState } from "react";
import { config } from "./config.js";

// 1. Auth: exchange the Cognito redirect for a token, or send the user to sign in.
function useAuth() {
  const [idToken, setIdToken] = useState(
    () => sessionStorage.getItem("psb_id_token") || "");

  useEffect(() => {
    const hash = new URLSearchParams(window.location.hash.slice(1));
    const token = hash.get("id_token");
    if (token) {
      sessionStorage.setItem("psb_id_token", token);
      setIdToken(token);
      window.history.replaceState({}, "", window.location.pathname);
    }
  }, []);

  const signIn = () => {
    const u = new URL(config.cognitoDomain + "/login");
    u.searchParams.set("client_id", config.userPoolClientId);
    u.searchParams.set("response_type", "token");
    u.searchParams.set("scope", "email openid");
    u.searchParams.set("redirect_uri", config.redirectUri);
    window.location.href = u.toString();
  };

  return { idToken, signIn };
}

// 2. Data: every API call carries the bearer token.
async function fetchSeries(idToken, path, params) {
  const url = new URL(config.apiBaseUrl + path);
  Object.entries(params).forEach(([k, v]) =>
    v != null && url.searchParams.set(k, v));
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${idToken}` },
  });
  if (res.status === 401) throw new Error("Session expired - sign in again.");
  if (!res.ok) throw new Error(`API returned ${res.status}`);
  return res.json();
}

// 3. Render: a metric selector, a summary strip, a chart, and (from Lab 08)
//    the assistant chat panel.

const METRICS = [
  { id: "temperature_c", label: "Temperature", unit: "°C" },
  { id: "humidity_pct", label: "Humidity", unit: "%" },
  { id: "co2_ppm", label: "CO₂", unit: "ppm" },
  { id: "vibration_g", label: "Vibration", unit: "g" },
  { id: "anomaly_score", label: "Anomaly score", unit: "" },
];
const WINDOWS = [
  { mins: 15, label: "15 minutes" },
  { mins: 60, label: "1 hour" },
  { mins: 360, label: "6 hours" },
  { mins: 1440, label: "24 hours" },
];
const COLORS = { "north-lab": "#2563eb", "south-lab": "#0d9488", "server-room": "#c2410c", all: "#6d28d9" };
const EXTRA_COLORS = ["#7c3aed", "#db2777", "#65a30d"];

function isConfigured() {
  return ![config.cognitoDomain, config.userPoolClientId, config.apiBaseUrl]
    .some((v) => !v || String(v).includes("<"));
}

// About 120 points per location, whatever the window.
function bucketSeconds(windowMins) {
  return Math.max(60, Math.round((windowMins * 60) / 120));
}

function fmt(v) {
  if (v === null || v === undefined || Number.isNaN(Number(v))) return "-";
  const n = Number(v);
  return Math.abs(n) >= 100 ? n.toFixed(1) : Math.abs(n) >= 1 ? n.toFixed(2) : n.toFixed(4);
}

function SummaryStrip({ summary, unit }) {
  const items = [
    ["Latest", summary?.latest],
    ["Min", summary?.min],
    ["Max", summary?.max],
    ["Mean", summary?.mean],
  ];
  return (
    <section className="summary">
      {items.map(([k, v]) => (
        <div className="stat card" key={k}>
          <span className="k">{k}</span>
          <span className="v">{fmt(v)}<small>{unit}</small></span>
        </div>
      ))}
      <div className="stat card">
        <span className="k">Points</span>
        <span className="v">{summary?.point_count ?? 0}</span>
      </div>
    </section>
  );
}

// Inline SVG line chart: one line per location.
function LineChart({ points, unit, windowMins }) {
  const W = 900, H = 320, P = { l: 64, r: 16, t: 16, b: 34 };
  const series = useMemo(() => {
    const groups = {};
    for (const p of points || []) {
      const t = Date.parse(p.time);
      if (Number.isNaN(t) || typeof p.value !== "number") continue;
      (groups[p.location] = groups[p.location] || []).push({ t, v: p.value });
    }
    Object.values(groups).forEach((g) => g.sort((a, b) => a.t - b.t));
    return groups;
  }, [points]);

  const all = Object.values(series).flat();
  if (all.length === 0) return <div className="card chart-empty">No data in this window yet.</div>;

  const tMin = Math.min(...all.map((d) => d.t));
  const tMax = Math.max(...all.map((d) => d.t));
  let vMin = Math.min(...all.map((d) => d.v));
  let vMax = Math.max(...all.map((d) => d.v));
  if (vMin === vMax) { vMin -= 1; vMax += 1; }
  const pad = (vMax - vMin) * 0.08;
  vMin -= pad; vMax += pad;
  const x = (t) => P.l + (tMax === tMin ? 0.5 : (t - tMin) / (tMax - tMin)) * (W - P.l - P.r);
  const y = (v) => P.t + (1 - (v - vMin) / (vMax - vMin)) * (H - P.t - P.b);
  const yTicks = [0, 1, 2, 3, 4].map((i) => vMin + ((vMax - vMin) * i) / 4);
  const xTicks = [0, 1, 2, 3, 4].map((i) => tMin + ((tMax - tMin) * i) / 4);
  const timeLabel = (ms) => {
    const d = new Date(ms);
    const hm = d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
    return windowMins > 720 ? `${d.toLocaleDateString([], { month: "short", day: "numeric" })} ${hm}` : hm;
  };
  const names = Object.keys(series).sort();
  const color = (name, i) => COLORS[name] || EXTRA_COLORS[i % EXTRA_COLORS.length];

  return (
    <section className="card chart-card">
      <div className="legend">
        {names.map((name, i) => (
          <span key={name}><i style={{ background: color(name, i) }} />{name} ({series[name].length})</span>
        ))}
      </div>
      <svg className="chart" viewBox={`0 0 ${W} ${H}`} role="img" aria-label="Telemetry chart">
        {yTicks.map((v, i) => (
          <g key={`y${i}`}>
            <line x1={P.l} x2={W - P.r} y1={y(v)} y2={y(v)} className="grid" />
            <text x={P.l - 8} y={y(v) + 4} className="axis" textAnchor="end">{fmt(v)}</text>
          </g>
        ))}
        {xTicks.map((t, i) => (
          <text key={`x${i}`} x={x(t)} y={H - 10} className="axis"
            textAnchor={i === 0 ? "start" : i === 4 ? "end" : "middle"}>{timeLabel(t)}</text>
        ))}
        <text x={14} y={P.t + 4} className="axis" transform={`rotate(-90 14 ${P.t + 4})`} textAnchor="end">{unit}</text>
        {names.map((name, i) => (
          <path key={name} fill="none" stroke={color(name, i)} strokeWidth="2" strokeLinejoin="round"
            d={series[name].map((d, j) => `${j ? "L" : "M"}${x(d.t).toFixed(1)},${y(d.v).toFixed(1)}`).join(" ")} />
        ))}
      </svg>
    </section>
  );
}

// Lab 08: chat panel (shown only when config.assistantEnabled is true).
function ChatPanel({ idToken, onExpired }) {
  const [question, setQuestion] = useState("");
  const [history, setHistory] = useState([]);
  const [busy, setBusy] = useState(false);

  const ask = async (e) => {
    e.preventDefault();
    const q = question.trim();
    if (!q || busy) return;
    setBusy(true);
    setQuestion("");
    try {
      const res = await fetch(config.apiBaseUrl + "/assistant", {
        method: "POST",
        headers: { Authorization: `Bearer ${idToken}`, "Content-Type": "application/json" },
        body: JSON.stringify({ question: q }),
      });
      if (res.status === 401) { onExpired(); throw new Error("Session expired - sign in again."); }
      const body = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(body.error || `API returned ${res.status}`);
      setHistory((h) => [...h, { q, answer: body.answer, trace: body.trace || [] }]);
    } catch (err) {
      setHistory((h) => [...h, { q, error: err.message }]);
    } finally {
      setBusy(false);
    }
  };

  return (
    <section className="card chat">
      <h2>Ask the assistant</h2>
      <div className="chat-log">
        {history.length === 0 && (
          <p className="muted">Example: What is the average CO2 in the server room over the last two hours?</p>
        )}
        {history.map((m, i) => (
          <div key={i} className="turn">
            <div className="bubble user">{m.q}</div>
            {m.error ? (
              <div className="bubble error">{m.error}</div>
            ) : (
              <div className="bubble assistant">
                {m.answer}
                {m.trace.length > 0 && (
                  <ul className="trace">
                    {m.trace.map((t, j) => (
                      <li key={j}>{t.tool}({Object.entries(t.input || {}).map(([k, v]) => `${k}=${v}`).join(", ")})</li>
                    ))}
                  </ul>
                )}
              </div>
            )}
          </div>
        ))}
        {busy && <div className="bubble assistant muted">Thinking...</div>}
      </div>
      <form className="chat-input" onSubmit={ask}>
        <input value={question} onChange={(e) => setQuestion(e.target.value)} maxLength={500}
          placeholder="Ask a question about the lab sensors" />
        <button type="submit" disabled={busy || !question.trim()}>Ask</button>
      </form>
    </section>
  );
}

export default function App() {
  const { idToken, signIn } = useAuth();
  const [expired, setExpired] = useState(false);
  const [metric, setMetric] = useState(config.defaultMetric || "temperature_c");
  const [windowMins, setWindowMins] = useState(Number(config.defaultWindowMins) || 60);
  const [data, setData] = useState(null);
  const [error, setError] = useState("");
  const [updated, setUpdated] = useState(null);
  const signedIn = Boolean(idToken) && !expired;
  const meta = METRICS.find((m) => m.id === metric) || METRICS[0];

  const onExpired = useCallback(() => {
    sessionStorage.removeItem("psb_id_token");
    setExpired(true);
  }, []);

  const load = useCallback(async () => {
    if (!signedIn) return;
    try {
      const path = metric === "anomaly_score" ? "/anomalies" : "/telemetry";
      const result = await fetchSeries(idToken, path, {
        metric: metric === "anomaly_score" ? null : metric,
        window_minutes: windowMins,
        bucket_seconds: bucketSeconds(windowMins),
      });
      setData(result);
      setError("");
      setUpdated(new Date());
    } catch (err) {
      if (String(err.message).startsWith("Session expired")) onExpired();
      setError(err.message);
    }
  }, [signedIn, idToken, metric, windowMins, onExpired]);

  useEffect(() => {
    load();
    const id = setInterval(load, (Number(config.refreshSeconds) || 30) * 1000);
    return () => clearInterval(id);
  }, [load]);

  if (!isConfigured()) {
    return (
      <div className="center card">
        <h1>PSB Lab Dashboard</h1>
        <p>Replace the placeholders in <code>src/config.js</code> (or <code>config.json</code> for the pre-built dist.zip) with your own values, then build and deploy again.</p>
      </div>
    );
  }

  if (!signedIn) {
    return (
      <div className="center card">
        <h1>PSB Lab Dashboard</h1>
        {expired && <p className="error-text">Session expired - sign in again.</p>}
        <p className="muted">Sign in with your Cognito user to view the sensor telemetry.</p>
        <button onClick={signIn}>Sign in</button>
      </div>
    );
  }

  return (
    <div className="app">
      <header className="topbar">
        <div>
          <h1>PSB Lab Sensors</h1>
          <span className="muted">psb-lab-sensor-01 | {config.region}</span>
        </div>
        <div className="muted">{updated ? `Updated ${updated.toLocaleTimeString()}` : "Loading..."}</div>
      </header>

      <main>
        <section className="controls card">
          <label>
            Metric
            <select value={metric} onChange={(e) => setMetric(e.target.value)}>
              {METRICS.map((m) => <option key={m.id} value={m.id}>{m.id}</option>)}
            </select>
          </label>
          <label>
            Window
            <select value={windowMins} onChange={(e) => setWindowMins(Number(e.target.value))}>
              {WINDOWS.map((w) => <option key={w.mins} value={w.mins}>{w.label}</option>)}
            </select>
          </label>
          <button className="ghost" onClick={load}>Refresh</button>
          <span className="muted">Auto refresh every {Number(config.refreshSeconds) || 30} s</span>
        </section>

        {error && <div className="alert">{error}</div>}

        <SummaryStrip summary={data?.summary} unit={meta.unit} />
        <LineChart points={data?.points} unit={meta.unit} windowMins={windowMins} />

        {config.assistantEnabled === true && <ChatPanel idToken={idToken} onExpired={onExpired} />}
      </main>
    </div>
  );
}
