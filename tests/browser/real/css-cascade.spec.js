const {test, expect} = require('@playwright/test');
const {installBackend} = require('./fixtures/backend.js');

for (const width of [1440, 390]) {
  test(`shared controls preserve component overrides at ${width}px`, async ({
    page
  }) => {
    await page.setViewportSize({width, height: 900});
    await installBackend(page, {browse: true, render: ''});
    await page.goto('/apps/graph-viz/');

    const collapse = page.locator('#explorer-collapse');
    await expect(collapse).toHaveCSS('border-radius', '0px');
    await expect(collapse).toHaveCSS('border-left-width', '1px');
    await expect(collapse).toHaveCSS('padding', '0px');
    await expect(collapse).toHaveCSS('flex-basis', '42.4px');

    await collapse.click();
    await expect(collapse).toHaveCSS('border-left-width', '0px');
    await expect(collapse).toHaveCSS('flex-basis', '48px');
    await collapse.click();

    if (width < 760) {
      await expect(page.locator('#explorer-resizer')).toHaveCSS(
        'display', 'none'
      );
      await expect(page.locator('#splitter')).toHaveCSS('display', 'none');
      await expect(page.locator('.preview-pane')).toHaveCSS(
        'border-top-width', '1px'
      );
      const columns = await page.locator('.visual-tools').evaluate(element => {
        return getComputedStyle(element).gridTemplateColumns.split(' ').length;
      });
      expect(columns).toBe(2);
    }

    await page.locator('#theme').selectOption('dark');
    await expect(page.locator('html')).toHaveAttribute(
      'data-effective-theme', 'dark'
    );
    await expect(page.locator('.preview-shell')).toHaveCSS(
      'background-color', 'rgb(17, 17, 15)'
    );

    await page.locator('#help').click();
    await expect(page.locator('#close-help')).toHaveCSS('width', '32px');
    await expect(page.locator('#close-help')).toHaveCSS('height', '32px');
  });
}
