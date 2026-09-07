const {defineConfig, devices} = require('@playwright/test');

const externalServer = Boolean(process.env.GVIZ_URL);
const baseURL = process.env.GVIZ_URL || 'http://127.0.0.1:4173';

module.exports = defineConfig({
  testDir: __dirname,
  testMatch: '*.spec.js',
  fullyParallel: false,
  forbidOnly: true,
  retries: 0,
  workers: 1,
  reporter: 'line',
  metadata: {
    acePlatform: 'win',
    keyboardLayout: 'en-US'
  },
  webServer: externalServer ? undefined : {
    command: 'node serve-app.js',
    url: `${baseURL}/apps/graph-viz/`,
    reuseExistingServer: false,
    timeout: 120_000
  },
  use: {
    ...devices['Desktop Chrome'],
    baseURL,
    locale: 'en-US',
    timezoneId: 'UTC',
    colorScheme: 'light',
    trace: 'off',
    screenshot: 'off',
    video: 'off'
  },
  projects: [{
    name: 'chromium-linux-win-keys',
    use: {browserName: 'chromium'}
  }]
});
