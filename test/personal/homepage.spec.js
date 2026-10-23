const { test, expect } = require("@playwright/test");

test("interactive article uses separate HTML, CSS and JS without losing its design", async ({ page }) => {
  await page.goto("/blog/2026/research-vision/");
  await expect(page.locator(".vision-card")).toHaveCount(6);
  await expect(page.locator('link[href*="/assets/css/blog/research-vision.css"]')).toHaveCount(1);
  await expect(page.locator('script[src*="/assets/js/blog/research-vision.js"]')).toHaveCount(1);
  await expect(page.locator(".vision-card").first()).toHaveCSS("border-top-style", "solid");
  await expect(page.locator(".vision-card").first()).toHaveCSS("border-top-width", "1px");
  await page.locator('[data-vision-language="zh"]').click();
  await expect(page.locator('[data-vision-panel="zh"]')).toBeVisible();
  await expect(page.locator('[data-vision-panel="en"]')).toBeHidden();
  expect(
    await page
      .locator(".vision-mission")
      .first()
      .evaluate((element) => getComputedStyle(element, "::after").animationName)
  ).toBe("mission-scan");
});

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
