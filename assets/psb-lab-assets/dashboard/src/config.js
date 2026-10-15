// PSB lab dashboard settings. Replace the <...> placeholders in Lab 05 Task 1.
//  - cognitoDomain: https://... with NO trailing slash
//  - apiBaseUrl:    the HTTP API invoke URL with NO trailing slash
//  - assistantEnabled: set to true in Lab 08 to show the chat panel
// At runtime, values in /config.json (if present, e.g. from dist.zip) override these.
const config = {
  region: 'ap-southeast-1',
  userPoolId: '<USER-POOL-ID>',
  userPoolClientId: '<CLIENT-ID>',
  cognitoDomain: 'https://<COGNITO-DOMAIN>',
  apiBaseUrl: 'https://<API-ID>.execute-api.ap-southeast-1.amazonaws.com',
  assistantEnabled: false,
};

export default config;
