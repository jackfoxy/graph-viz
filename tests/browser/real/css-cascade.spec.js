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

    for (const [button, key] of [['help', 'F1'], ['settings', 'F2']]) {
      await expect(page.locator(`#${button}`))
        .toHaveAttribute('aria-keyshortcuts', key);
      await expect(page.locator(`#${button}`))
        .toHaveAttribute('title', new RegExp(key));
      await expect(page.locator(`#${button} kbd`)).toHaveText(key);
    }

    const autoRenderSetting = page.locator(
      '#settings-modal .settings-card > .source-auto-render'
    );
    await expect(autoRenderSetting).toHaveCount(1);
    await expect(page.locator('#editor-pane-tools #auto-render')).toHaveCount(0);
    await expect(autoRenderSetting).toHaveClass(/settings-field/);
    await expect(autoRenderSetting).toHaveClass(/preference/);
    await expect(autoRenderSetting).toHaveClass(/source-auto-render/);
    await expect(autoRenderSetting).toHaveJSProperty(
      'nextElementSibling', null
    );

    for (const [selector, label] of [
      ['#dot-save', 'Save this DOT'], ['#svg-save', 'Save this SVG']
    ]) {
      await expect(page.locator(selector)).toHaveAttribute(
        'aria-label', label
      );
      await expect(page.locator(`${selector} .save-icon`)).toHaveCount(1);
    }
    for (const [selector, label] of [
      ['#dot-copy', 'Copy DOT to clipboard'],
      ['#svg-copy', 'Copy SVG to clipboard']
    ]) {
      await expect(page.locator(selector)).toHaveAttribute('title', label);
      await expect(page.locator(selector)).toHaveAttribute(
        'aria-label', label
      );
      await expect(page.locator(`${selector} .copy-icon`)).toHaveCount(1);
    }
    const dotActionOrder = await page.locator(
      '#editor-pane-head .pane-actions'
    ).evaluate((actions) => Array.from(actions.children).map((item) => {
      return item.id;
    }));
    expect(dotActionOrder.indexOf('dot-copy')).toBe(
      dotActionOrder.indexOf('dot-save-as') + 1
    );
    expect(dotActionOrder.indexOf('dot-ref')).toBe(
      dotActionOrder.indexOf('dot-copy') + 1
    );
    const sourceButtonHeight = await page.locator('#dot-open').evaluate(
      element => element.getBoundingClientRect().height
    );
    for (const selector of [
      '#dot-save', '#dot-save-as', '#dot-copy', '#dot-ref',
      '#svg-open', '#svg-save', '#svg-save-as', '#svg-copy', '#svg-ref'
    ]) {
      await expect.poll(() => page.locator(selector).evaluate(
        element => element.getBoundingClientRect().height
      )).toBe(sourceButtonHeight);
    }
    for (const selector of [
      '#svg-display-source', '#svg-display-preview'
    ]) {
      const centerOffset = await page.locator(selector).evaluate((button) => {
        const buttonBox = button.getBoundingClientRect();
        const labelBox = button.querySelector('p').getBoundingClientRect();
        const buttonCenter = buttonBox.top + buttonBox.height / 2;
        const labelCenter = labelBox.top + labelBox.height / 2;
        return Math.abs(buttonCenter - labelCenter);
      });
      expect(centerOffset).toBeLessThan(1);
    }
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
    } else {
      //  the node tools sit side by side across the band, not stacked
      const columns = await page.locator('.visual-tools').evaluate(element => {
        return getComputedStyle(element).gridTemplateColumns.split(' ').length;
      });
      expect(columns).toBeGreaterThan(2);
    }

    await page.locator('#settings').click();
    const topicMargins = await page.locator(
      '#settings-modal .settings-card > .settings-field'
    ).evaluateAll(fields => fields.map(
      field => getComputedStyle(field).marginTop
    ));
    expect(topicMargins).toEqual(['16px', '16px', '16px', '16px']);
    await expect(autoRenderSetting).toHaveCSS('display', 'inline-flex');
    const autoRenderAlignment = await autoRenderSetting.evaluate((label) => {
      const checkboxBox = label.querySelector('input').getBoundingClientRect();
      const textBox = label.querySelector('span').getBoundingClientRect();
      return {
        checkboxBeforeLabel: checkboxBox.right < textBox.left,
        centerOffset: Math.abs(
          checkboxBox.top + checkboxBox.height / 2
          - textBox.top - textBox.height / 2
        )
      };
    });
    expect(autoRenderAlignment.checkboxBeforeLabel).toBe(true);
    expect(autoRenderAlignment.centerOffset).toBeLessThan(1);
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
