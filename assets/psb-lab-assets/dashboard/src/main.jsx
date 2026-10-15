import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import baseConfig from './config.js';
import { setConfig } from './api.js';
import './styles.css';

// Load optional /config.json (used by the prebuilt dist.zip) and merge it over src/config.js.
async function loadConfig() {
  let merged = { ...baseConfig };
  try {
    const res = await fetch('/config.json', { cache: 'no-store' });
    if (res.ok && (res.headers.get('content-type') || '').includes('json')) {
      merged = { ...merged, ...(await res.json()) };
    }
  } catch {
    // no config.json: keep src/config.js values
  }
  const strip = (s) => (typeof s === 'string' ? s.replace(/\/+$/, '') : s);
  merged.cognitoDomain = strip(merged.cognitoDomain);
  merged.apiBaseUrl = strip(merged.apiBaseUrl);
  return merged;
}

loadConfig().then((config) => {
  setConfig(config);
  createRoot(document.getElementById('root')).render(
    <React.StrictMode>
      <App config={config} />
    </React.StrictMode>
  );
});
