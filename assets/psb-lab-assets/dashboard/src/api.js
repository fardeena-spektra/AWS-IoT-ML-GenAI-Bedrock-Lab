// Small fetch wrapper for the PSB HTTP API. Sends the Cognito id_token as a Bearer token.
let cfg = null;
export function setConfig(c) {
  cfg = c;
}

export class AuthError extends Error {}

async function request(path, { method = 'GET', token, body } = {}) {
  const res = await fetch(`${cfg.apiBaseUrl}${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      ...(body ? { 'Content-Type': 'application/json' } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401) throw new AuthError(`HTTP ${res.status}`);
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || data.message || `HTTP ${res.status}`);
  return data;
}

export function getTelemetry(token, { metric, windowMinutes, location }) {
  const bucket = windowMinutes <= 60 ? 60 : Math.max(60, Math.round((windowMinutes * 60) / 120));
  const qs = new URLSearchParams({ metric, window_minutes: String(windowMinutes), bucket_seconds: String(bucket) });
  if (location) qs.set('location', location);
  return request(`/telemetry?${qs}`, { token });
}

export function getAnomalies(token, { windowMinutes, location }) {
  const qs = new URLSearchParams({ window_minutes: String(windowMinutes) });
  if (location) qs.set('location', location);
  return request(`/anomalies?${qs}`, { token });
}

export function askAssistant(token, question) {
  return request('/assistant', { method: 'POST', token, body: { question } });
}
