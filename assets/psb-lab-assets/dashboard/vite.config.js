import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// PSB lab dashboard: dev server on http://localhost:5173/ (matches the Cognito return URL)
export default defineConfig({
  plugins: [react()],
  server: { port: 5173, strictPort: true },
  preview: { port: 5173, strictPort: true },
});
