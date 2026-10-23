const { test, expect } = require("@playwright/test");

test("all news can be scrolled within the homepage", async ({ page }) => {
  await page.goto("/");
  const news = page.locator(".home-news-scroll");
  await expect(news.locator("tr")).toHaveCount(
    require("node:fs")
      .readdirSync("_news")
      .filter((file) => file.endsWith(".md")).length
  );
  expect(await news.evaluate((element) => element.scrollHeight > element.clientHeight)).toBe(true);
  await news.focus();
  await page.keyboard.press("End");
  await expect.poll(() => news.evaluate((element) => element.scrollTop)).toBeGreaterThan(0);
});

test("publication notes appear immediately on hover and keyboard focus", async ({ page }) => {
  await page.goto("/publications/");
  const trigger = page.locator(".publication-note-trigger").first();
  await trigger.scrollIntoViewIfNeeded();
  await trigger.hover();
  const tooltip = page.locator(".publication-note.is-visible");
  await expect(tooltip).toBeVisible({ timeout: 250 });
  await expect(trigger).not.toHaveAttribute("title");
  await page.keyboard.press("Escape");
  await expect(tooltip).toHaveCount(0);
  await trigger.focus();
  await expect(tooltip).toBeVisible();
  await page.keyboard.press("Escape");
  await trigger.click();
  await expect(tooltip).toBeVisible();
});
