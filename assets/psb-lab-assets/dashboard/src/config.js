// PSB Academy CloudLab - dashboard configuration.
// Replace every <PLACEHOLDER> with the value from your own lab environment.

export const config = {
  region: "ap-southeast-1",

  // From Lab 04, Task 1
  userPoolId:        "<USER-POOL-ID>",
  userPoolClientId:  "<CLIENT-ID>",
  cognitoDomain:     "<COGNITO-DOMAIN>",

  // From Lab 03, Task 2
  apiBaseUrl:        "<INVOKE-URL>",

  // Leave as-is
  redirectUri:       window.location.origin + "/",
  defaultMetric:     "temperature_c",
  defaultWindowMins: 60,
  refreshSeconds:    30,
};
