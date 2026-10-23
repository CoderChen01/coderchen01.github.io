const { defineConfig } = require("@playwright/test");

module.exports = defineConfig({
  testDir: ".",
  testMatch: "*.spec.js",
  use: { baseURL: process.env.SITE_TEST_URL || "http://127.0.0.1:4100", browserName: "chromium", channel: process.env.CI ? undefined : "chrome" },
  webServer: process.env.SITE_TEST_URL
    ? undefined
    : {
        cwd: require("node:path").resolve(__dirname, "../.."),
        command: "python3 -m http.server 4100 --bind 127.0.0.1 --directory _site",
        url: "http://127.0.0.1:4100",
        reuseExistingServer: !process.env.CI,
      },
});
