const {test, expect} = require('@playwright/test');

test('Ace initialization failure shows actionable UI', async ({page}) => {
  await page.addInitScript(() => {
    Object.defineProperty(window, 'ace', {
      configurable: false,
      get: () => undefined,
      set: () => undefined
    });
  });
  await page.goto('/apps/graph-viz/');

  const problem = page.locator('#editor-load-error');
  await expect(problem).toBeVisible();
  await expect(problem).toContainText('Reload the page');
  await expect(problem).toContainText('verify the Ace assets are installed');
  await expect(page.locator('#dot')).toBeHidden();
});
