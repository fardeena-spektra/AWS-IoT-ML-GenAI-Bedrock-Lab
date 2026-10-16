import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App.jsx";
import { config } from "./config.js";
import "./styles.css";

// The pre-built dist.zip ships a config.json at the site root. When it is present,
// its values are merged over src/config.js. A normal build has no config.json.
async function loadRuntimeConfig() {
  try {
    const res = await fetch("/config.json", { cache: "no-store" });
    const type = res.headers.get("content-type") || "";
    if (res.ok && type.includes("json")) {
      const extra = await res.json();
      delete extra.redirectUri;
      Object.assign(config, extra);
    }
  } catch {
    // no config.json: use src/config.js as built
  }
  for (const key of ["cognitoDomain", "apiBaseUrl"]) {
    if (typeof config[key] === "string") config[key] = config[key].replace(/\/+$/, "");
  }
}

loadRuntimeConfig().then(() => {
  createRoot(document.getElementById("root")).render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
});
