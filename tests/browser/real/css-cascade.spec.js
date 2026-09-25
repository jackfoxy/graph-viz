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

    for (const strip of [
      '#editor-pane-document-tabs',
      '#preview-pane-document-tabs'
    ]) {
      await expect(page.locator(strip)).toHaveCSS('border-top-width', '1px');
      await expect(page.locator(strip)).toHaveCSS('border-top-style', 'solid');
    }

    if (width < 760) {
      //  Narrow no longer restacks the panes or drops their dividers:
      //  the screen format is the user's choice at every width, and
      //  every divider stays draggable.
      await expect(page.locator('#explorer-resizer')).not.toHaveCSS(
        'display', 'none'
      );
      await expect(page.locator('#splitter')).not.toHaveCSS(
        'display', 'none'
      );
      await expect(page.locator('#workspace')).toHaveAttribute(
        'data-layout', 'columns'
      );
      //  the render pane's divider border belongs to the rows format
      await expect(page.locator('.preview-pane')).toHaveCSS(
        'border-top-width', '0px'
      );
      const columns = await page.locator('.visual-tools').evaluate(element => {
        return getComputedStyle(element).gridTemplateColumns.split(' ').length;
      });
      expect(columns).toBe(2);
    }

    await page.locator('#settings').click();
    await page.locator('#theme').selectOption('dark');
    await page.locator('#close-settings').click();
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
