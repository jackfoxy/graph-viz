::  urui-js: the shared browser runtime, as cords.
::
|%
::
++  theme-bootstrap
  ::  Read a stored theme before first paint.
  ::
  |=  [storage-key=@t version=@ud]
  ^-  @t
  =/  key  (en:json:html s+storage-key)
  =/  ver  (scot %ud version)
  %+  rap  3
  :~  '''
      (() => {
        const key =
      '''
      key
      '''
      ;
        const themes = ['system', 'light', 'dark'];
        let selected = 'system';
        try {
          const saved = JSON.parse(localStorage.getItem(key));
          const candidate = saved?.preferences?.theme;
          if (saved?.version ===
      '''
      ver
      '''
       && themes.includes(candidate)) {
            selected = candidate;
          }
        } catch (_) {
          // Storage failures must not block first paint.
        }
        const systemDark = matchMedia(
          '(prefers-color-scheme: dark)'
        ).matches;
        const effective = selected === 'system'
          ? (systemDark ? 'dark' : 'light')
          : selected;
        const root = document.documentElement;
        root.dataset.theme = selected;
        root.dataset.effectiveTheme = effective;
        root.style.colorScheme = effective;
      })();
      '''
  ==
::
++  core
  ::  Define the stable API before the consumer installs its hooks.
  ::
  ^-  @t
  %+  rap  3
  :~  '''
      (() => {
        'use strict';
        let hooks = Object.create(null);
        let booted = false;

        function invoke(group, method, args) {
          const owner = group ? hooks[group] : hooks;
          const target = owner?.[method];
          if (typeof target !== 'function') return undefined;
          return target(...args);
        }

        function methods(group, names) {
          return Object.freeze(Object.fromEntries(names.map((name) => [
            name,
            (...args) => invoke(group, name, args)
          ])));
        }

        function createAceEditorAdapter(host, options = {}) {
      '''
      editor-adapter
      '''
        }

        function createRuntime(options = {}) {
      '''
      runtime
      '''
        }

        const editor = Object.freeze({
          ...methods('editor', ['primary', 'secondary']),
          adapter: createAceEditorAdapter
        });
        const api = {
          config: Object.freeze(window.URUI_CONFIG || {}),
          boot(next = {}) {
            if (booted) throw new Error('urui.boot called more than once');
            if (!next || typeof next !== 'object') {
              throw new TypeError('urui.boot requires a hook object');
            }
            hooks = next;
            booted = true;
            invoke(null, 'onReady', [api]);
            return api;
          },
          status: (...args) => invoke(null, 'status', args),
          tabs: methods('tabs', [
            'create', 'close', 'select', 'update', 'list', 'active'
          ]),
          editor,
          explorer: methods('explorer', [
            'show', 'refreshTree', 'addRef', 'openDocs'
          ]),
          dialog: Object.freeze({
            help: (...args) => invoke('dialog', 'help', args),
            error: (...args) => invoke('dialog', 'error', args),
            confirm: (...args) => {
              const answer = invoke('dialog', 'confirm', args);
              return answer === undefined ? window.confirm(...args) : answer;
            },
            prompt: (...args) => {
              const answer = invoke('dialog', 'prompt', args);
              return answer === undefined ? window.prompt(...args) : answer;
            }
          }),
          session: methods('session', ['save', 'queue', 'get', 'set']),
          files: methods('files', ['browse', 'load', 'save', 'delete']),
          shortcuts: methods('shortcuts', ['register']),
          layout: methods('layout', ['paneWidth', 'explorerWidth']),
          problem: methods('problem', ['show', 'clear']),
          runtime: createRuntime
        };
        for (const value of Object.values(api)) {
          if (value && typeof value === 'object') Object.freeze(value);
        }
        window.urui = Object.freeze(api);
      })();
      '''
  ==
::
++  runtime
  ::  The body of createRuntime: shell behavior every consumer shares.
  ::
  ::  The runtime owns the frame urui emits — theme, status lines, the
  ::  two resizers, explorer collapse, the help panel, the Clay error
  ::  dialog, document tabs, the explorer (permanent views, docs tabs,
  ::  ref tabs, the Clay file tree and its context menu), and session
  ::  persistence, Clay file operations, and shortcut dispatch.
  ::  It reads its policy from `window.URUI_CONFIG` and reaches the frame
  ::  through `data-role` and the ids `urui-shell` fixes, so nothing here
  ::  names a consumer. Section banners mark each responsibility;
  ::  ++files and ++shortcuts are composed into the same lexical scope.
  ::
  ::  `options.editors` supplies the Ace adapters to resize and re-theme;
  ::  `options.onChange` is called whenever a persisted value moves;
  ::  `options.tabs[kindName]` and the explorer/session options are
  ::  documented at their own section banner, not repeated here.
  ^-  @t
  %+  rap  3
  :~
  '''
  const config = window.URUI_CONFIG || {};
  const limits = config.limits || {};
  const paneMin = limits.paneMin ?? 25;
  const paneMax = limits.paneMax ?? 70;
  const minExplorer = limits.minExplorer ?? 180;
  const dividerWidth = limits.divider ?? 10;
  const narrowMedia = matchMedia(`(max-width: ${limits.narrow ?? 760}px)`);
  const themes = ['system', 'light', 'dark'];
  const themeMedia = matchMedia('(prefers-color-scheme: dark)');
  const statusLabels = new Map(
    (config.statuses || []).map((entry) => [entry.name, entry.label])
  );
  const role = (name) => document.querySelector(`[data-role="${name}"]`);
  const elements = {
    workbench: document.querySelector('#workbench'),
    workspace: document.querySelector('#workspace'),
    splitter: document.querySelector('#splitter'),
    explorerPane: role('reference'),
    explorerResizer: document.querySelector('#explorer-resizer'),
    explorerCollapse: document.querySelector('#explorer-collapse'),
    explorerTabs: document.querySelector('#explorer-tabs'),
    editorPane: role('editor'),
    resultPane: role('result'),
    themeControl: document.querySelector('#theme'),
    helpToggle: document.querySelector('#help'),
    helpPanel: document.querySelector('#help-panel'),
    closeHelp: document.querySelector('#close-help'),
    errorModal: document.querySelector('#clay-error-modal'),
    errorMessage: document.querySelector('#clay-error-message'),
    closeError: document.querySelector('#close-clay-error'),
    contextMenu: document.querySelector('#file-context-menu'),
    contextOpen: document.querySelector('#file-context-open'),
    contextDelete: document.querySelector('#file-context-delete'),
    fallbackHelp: document.querySelector('#fallback-help-content'),
    docsHelp: document.querySelector('#docs-help-content'),
    docsHelpNav: document.querySelector('#docs-help-nav'),
    ...(options.elements || {})
  };
  let explorerOpen = true;
  let refreshQueued = false;
  let errorReturnFocus;

  function changed() {
    if (options.onChange) options.onChange();
    else queueSaveSession();
  }

  function clamp(value, minimum, maximum) {
    return Math.min(maximum, Math.max(minimum, value));
  }

  function editors() {
    const source = options.editors;
    const list = typeof source === 'function' ? source() : source;
    return (list || []).filter(Boolean);
  }

  // One resize per frame: a drag emits pointermove far faster than Ace
  // can lay out, and an unbatched call makes the cursor lag the divider.
  function refreshEditors() {
    if (refreshQueued) return;
    refreshQueued = true;
    requestAnimationFrame(() => {
      refreshQueued = false;
      for (const item of editors()) item.refresh?.();
    });
  }

  function validTheme(candidate) {
    return themes.includes(candidate) ? candidate : 'system';
  }

  function selectedTheme() {
    return elements.themeControl
      ? elements.themeControl.value
      : document.documentElement.dataset.theme;
  }

  function applyTheme(candidate, persist = true) {
    const selected = validTheme(candidate);
    const effective = selected === 'system'
      ? (themeMedia.matches ? 'dark' : 'light')
      : selected;
    if (elements.themeControl) elements.themeControl.value = selected;
    const root = document.documentElement;
    root.dataset.theme = selected;
    root.dataset.effectiveTheme = effective;
    root.style.colorScheme = effective;
    for (const item of editors()) item.setTheme?.(effective);
    options.onTheme?.(effective, selected);
    if (persist) changed();
    return effective;
  }

  function systemThemeChanged() {
    if (selectedTheme() === 'system') applyTheme('system', false);
  }

  function statusNode(name) {
    const named = name === 'editor'
      ? elements.editorStatus
      : elements.resultStatus;
    if (named) return named;
    const pane = name === 'editor' ? elements.editorPane : elements.resultPane;
    return pane?.querySelector('.status, .pane-status');
  }

  function setStatus(name, state) {
    const node = statusNode(name);
    const label = statusLabels.has(state) ? statusLabels.get(state) : state;
    if (node) node.textContent = label;
    return label;
  }

  function paneWidth() {
    const value = getComputedStyle(elements.workspace)
      .getPropertyValue('--editor-width');
    return clamp(parseFloat(value) || 44, paneMin, paneMax);
  }

  function setPaneWidth(width, persist = true) {
    const next = clamp(width, paneMin, paneMax);
    elements.workspace.style.setProperty('--editor-width', `${next}%`);
    refreshEditors();
    if (persist) changed();
    return next;
  }

  function maxExplorerWidth() {
    const bounds = elements.workbench.getBoundingClientRect();
    return Math.max(minExplorer, bounds.width - dividerWidth);
  }

  function explorerWidth() {
    const value = getComputedStyle(elements.workbench)
      .getPropertyValue('--explorer-width');
    return clamp(parseFloat(value) || 288, minExplorer, maxExplorerWidth());
  }

  function setExplorerWidth(width, persist = false) {
    const next = clamp(width, minExplorer, maxExplorerWidth());
    elements.workbench.style.setProperty('--explorer-width', `${next}px`);
    refreshEditors();
    if (persist) changed();
    return next;
  }

  function applyExplorerLayout() {
    elements.explorerPane.classList.toggle('collapsed', !explorerOpen);
    elements.workbench.classList.toggle('explorer-collapsed', !explorerOpen);
    elements.explorerResizer.classList.toggle('inactive', !explorerOpen);
    elements.explorerResizer.disabled = !explorerOpen;
    elements.explorerCollapse.setAttribute(
      'aria-expanded',
      String(explorerOpen)
    );
    elements.explorerCollapse.setAttribute(
      'aria-label',
      explorerOpen ? 'Collapse explorer' : 'Expand explorer'
    );
    elements.explorerCollapse.textContent = explorerOpen ? '‹' : '›';
    refreshEditors();
  }

  function setExplorerOpen(open, persist = true) {
    explorerOpen = open !== false;
    applyExplorerLayout();
    if (persist) changed();
    return explorerOpen;
  }

  function helpIsOpen() {
    return !elements.helpPanel.hidden;
  }

  function setHelpOpen(open, restoreFocus = false) {
    elements.helpPanel.hidden = !open;
    elements.helpToggle?.setAttribute('aria-expanded', String(open));
    if (open) {
      setHelpVariant(docsAvailable === true);
      refreshHelpVariant();
      options.onHelpOpen?.();
      elements.closeHelp.focus();
    }
    if (!open && restoreFocus) elements.helpToggle?.focus();
  }

  function showError(cause) {
    if (!elements.errorModal.contains(document.activeElement)) {
      errorReturnFocus = document.activeElement;
    }
    elements.errorMessage.textContent = String(cause);
    elements.errorModal.hidden = false;
    elements.closeError.focus();
  }

  function hideError() {
    elements.errorModal.hidden = true;
    errorReturnFocus?.focus?.();
    errorReturnFocus = undefined;
  }

  function errorIsOpen() {
    return !elements.errorModal.hidden;
  }


  // ---- document tabs ------------------------------------------------
  //
  // One store per `config.kinds` entry.  Everything structural lives
  // here; a consumer supplies only what differs between its kinds,
  // through `options.tabs[kindName]`:
  //
  //   defaults(options, source)  extra fields for a new tab
  //   dirty(tab)                 override the source/cleanSource comparison
  //   onCapture(tab)             copy live editor state into the tab
  //   onActivate(tab, …)         react to the active id moving, before render
  //   afterActivate(…)           react after render and persistence
  //   onClose(tab)               react to a tab leaving the store
  //   empty()                    react to the store just emptying
  //   add                        label for the `+` control, absent for none
  const kinds = config.kinds || [];
  const kindByName = new Map(kinds.map((kind) => [kind.name, kind]));
  const stores = new Map(kinds.map((kind) => [kind.name, {
    tabs: [], activeId: undefined, next: 1
  }]));
  const tabHooks = (name) => (options.tabs || {})[name] || {};
  let draggedTab;

  function store(name) {
    const found = stores.get(name);
    if (!found) throw new Error(`unknown document kind: ${name}`);
    return found;
  }

  function tabList(name) {
    return store(name).tabs;
  }

  function activeTabId(name) {
    return store(name).activeId;
  }

  function activeTab(name) {
    return tabList(name).find((tab) => tab.id === activeTabId(name));
  }

  function getTab(name, id) {
    return tabList(name).find((tab) => tab.id === id);
  }

  //  A path's last segment is the clay leaf, not a file name: a kind
  //  stored under `%txt` and labelled `.foo` shows `left/txt` as
  //  `left.foo`.
  function tabLabel(name, path) {
    const kind = kindByName.get(name);
    if (!path) return kind?.untitled || 'Untitled';
    const parts = path.split('/');
    const leaf = parts.at(-1);
    if (kind && leaf === kind.leaf && parts.length > 1) {
      return `${parts.at(-2)}.${kind.ext}`;
    }
    return leaf;
  }

  function tabDirty(name, tab) {
    const hook = tabHooks(name).dirty;
    return hook ? hook(tab) : tab.source !== tab.cleanSource;
  }

  function createTab(name, source, options = {}) {
    const hooks = tabHooks(name);
    const state = store(name);
    const tab = {
      id: `${name}-${state.next++}`,
      label: options.label || tabLabel(name, options.path),
      path: options.path,
      source,
      cleanSource: options.cleanSource ?? source,
      ...(hooks.defaults ? hooks.defaults(options, source) : {})
    };
    state.tabs.push(tab);
    return tab;
  }

  function captureTab(name) {
    const tab = activeTab(name);
    if (!tab) return undefined;
    tabHooks(name).onCapture?.(tab);
    syncRefFromParent(name, tab.id);
    return tab;
  }

  function tabContainer(name) {
    return document.querySelector(`#${name}-document-tabs`);
  }

  function focusTab(name, id) {
    tabContainer(name)?.querySelector(`[data-document-tab="${id}"]`)?.focus();
  }

  function tabKeydown(event, name) {
    if (!['ArrowLeft', 'ArrowRight', 'Home', 'End']
      .includes(event.key)) return;
    event.preventDefault();
    const tabs = tabList(name);
    const current = tabs.findIndex((tab) => {
      return tab.id === event.currentTarget.dataset.documentTab;
    });
    let next = current;
    if (event.key === 'Home') next = 0;
    else if (event.key === 'End') next = tabs.length - 1;
    else if (event.key === 'ArrowLeft') {
      next = (current - 1 + tabs.length) % tabs.length;
    } else {
      next = (current + 1) % tabs.length;
    }
    selectTab(name, tabs[next].id, {focus: true});
  }

  function moveTab(name, sourceId, targetId, after) {
    const explorer = !stores.has(name);
    const order = explorer
      ? explorerOrder
      : tabList(name).map((tab) => tab.id);
    const source = order.indexOf(sourceId);
    const target = order.indexOf(targetId);
    if (source < 0 || target < 0 || source === target) return;
    order.splice(source, 1);
    let insertion = order.indexOf(targetId) + (after ? 1 : 0);
    insertion = Math.max(0, Math.min(order.length, insertion));
    order.splice(insertion, 0, sourceId);
    if (explorer) {
      explorerOrder = order;
      syncExplorerTabOrder();
    } else {
      //  reorder in place: a consumer may hold this array by reference
      const tabs = tabList(name);
      const byId = new Map(tabs.map((tab) => [tab.id, tab]));
      tabs.splice(0, tabs.length, ...order.map((id) => byId.get(id)));
      renderTabs(name);
    }
    changed();
  }

  function enableTabDrag(wrapper, name, id) {
    if (wrapper.dataset.dragEnabled) return;
    wrapper.dataset.dragEnabled = 'true';
    wrapper.draggable = true;
    wrapper.addEventListener('dragstart', (event) => {
      draggedTab = {kind: name, id};
      wrapper.classList.add('is-dragging');
      event.dataTransfer?.setData('text/plain', id);
      if (event.dataTransfer) event.dataTransfer.effectAllowed = 'copyMove';
    });
    wrapper.addEventListener('dragover', (event) => {
      if (draggedTab?.kind !== name) return;
      event.preventDefault();
      if (event.dataTransfer) event.dataTransfer.dropEffect = 'move';
    });
    wrapper.addEventListener('drop', (event) => {
      if (draggedTab?.kind !== name) return;
      event.preventDefault();
      const bounds = wrapper.getBoundingClientRect();
      const after = event.clientX > bounds.left + bounds.width / 2;
      moveTab(name, draggedTab.id, id, after);
    });
    wrapper.addEventListener('dragend', () => {
      wrapper.classList.remove('is-dragging');
      draggedTab = undefined;
    });
  }

  function renderTabs(name) {
    const container = tabContainer(name);
    if (!container) return;
    const activeId = activeTabId(name);
    container.replaceChildren();
    for (const tab of tabList(name)) {
      const wrapper = document.createElement('div');
      wrapper.className = 'document-tab-control';
      wrapper.classList.toggle('active', tab.id === activeId);
      const control = document.createElement('button');
      control.type = 'button';
      control.className = 'document-tab';
      control.dataset.documentTab = tab.id;
      control.setAttribute('role', 'tab');
      control.setAttribute('aria-selected', String(tab.id === activeId));
      control.tabIndex = tab.id === activeId ? 0 : -1;
      control.textContent = tab.label;
      control.title = tab.path || tab.label;
      control.addEventListener('click', () => selectTab(name, tab.id));
      control.addEventListener('keydown', (event) => tabKeydown(event, name));
      const close = document.createElement('button');
      close.type = 'button';
      close.className = 'document-tab-close';
      const dirty = tabDirty(name, tab);
      close.textContent = dirty ? 'O' : 'X';
      close.title = dirty ? 'Unsaved changes; close tab' : 'Close tab';
      close.setAttribute('aria-label', `Close ${tab.label}`);
      close.addEventListener('click', (event) => {
        event.stopPropagation?.();
        closeTab(name, tab.id);
      });
      wrapper.append(control, close);
      enableTabDrag(wrapper, name, tab.id);
      container.append(wrapper);
    }
    const addLabel = tabHooks(name).add;
    if (addLabel) {
      const wrapper = document.createElement('div');
      wrapper.className = 'document-tab-control document-tab-add-control';
      wrapper.setAttribute('role', 'presentation');
      const add = document.createElement('button');
      add.type = 'button';
      add.className = 'document-tab-add';
      add.setAttribute('aria-label', addLabel);
      add.title = addLabel;
      add.textContent = '+';
      add.addEventListener('click', () => addEmptyTab(name));
      wrapper.append(add);
      container.append(wrapper);
    }
    updateRefActions();
    options.onTabsRendered?.(name);
  }

  function addEmptyTab(name) {
    const kind = kindByName.get(name);
    const tab = createTab(name, '', {label: kind?.untitled || 'Untitled'});
    selectTab(name, tab.id, {focus: true});
    return tab;
  }

  function selectTab(name, id, choices = {}) {
    const {focus = false, capture = true} = choices;
    const tab = getTab(name, id);
    if (!tab) return undefined;
    if (capture && id === activeTabId(name)) {
      if (focus) focusTab(name, id);
      return tab;
    }
    if (capture) captureTab(name);
    const previousId = activeTabId(name);
    store(name).activeId = id;
    tabHooks(name).onActivate?.(tab, {...choices, previousId});
    renderTabs(name);
    changed();
    tabHooks(name).afterActivate?.(tab, {...choices, previousId});
    if (focus) focusTab(name, id);
    return tab;
  }

  function closeTab(name, id) {
    captureTab(name);
    const tabs = tabList(name);
    const index = tabs.findIndex((tab) => tab.id === id);
    if (index < 0) return;
    const tab = tabs[index];
    if (tabDirty(name, tab)
      && !window.confirm(`Discard unsaved changes in ${tab.label}?`)) {
      return;
    }
    const wasActive = id === activeTabId(name);
    tabs.splice(index, 1);
    tabHooks(name).onClose?.(tab);
    if (!tabs.length) tabHooks(name).empty?.();
    if (wasActive) {
      store(name).activeId = undefined;
      const next = tabs[Math.min(index, tabs.length - 1)];
      selectTab(name, next.id, {focus: true, capture: false});
    } else {
      renderTabs(name);
      changed();
    }
  }


  // ---- explorer -----------------------------------------------------
  //
  // The aside holds three kinds of view in one tab strip: the permanent
  // file trees named by `config.permanentViews`, documentation tabs
  // backed by iframes, and reference tabs mirroring an open document.
  // All three share the strip's order, which the user can drag.
  //
  // Clay networking is shared with the file-operation section below.
  const permanentViews = (config.permanentViews || []).map((view) => {
    return view.name;
  });
  const firstView = permanentViews[0] || '';
  const docsRoot = config.docsRoot || '';
  const appTitle = String(config.appId?.title || '').toLowerCase();
  let explorerView = firstView;
  let explorerOrder = [...permanentViews];
  const docsTabs = [];
  let nextDocs = 1;
  const refTabs = [];
  let nextRef = 1;
  let docsAvailable = null;
  let docsCheckPending = false;
  let docsTreeLoaded = false;
  let contextTarget = {};

  //  the permanent views come from the page; the strip's reorder keys
  //  every wrapper the same way, so stamp them once
  for (const name of permanentViews) {
    const tab = document.querySelector(`#${name}-tab`);
    if (tab?.parentElement) tab.parentElement.dataset.explorerTabId = name;
  }

  //  a permanent view owns the tree for the kind it is named after
  function viewForKind(name) {
    return `${name}-files`;
  }

  function treeForKind(name) {
    return document.querySelector(`#${viewForKind(name)}-tree`);
  }

  function docsTabById(id) {
    return docsTabs.find((tab) => tab.id === id);
  }

  function refTabById(id) {
    return refTabs.find((tab) => tab.id === id);
  }

  function explorerTabButtons() {
    if (!elements.explorerTabs) return [];
    return Array.from(elements.explorerTabs.querySelectorAll('[role="tab"]'));
  }

  function validExplorerView(name) {
    return permanentViews.includes(name)
      || Boolean(docsTabById(name)) || Boolean(refTabById(name));
  }

  function setExplorerView(name, focus = false) {
    explorerView = validExplorerView(name) ? name : firstView;
    for (const tab of explorerTabButtons()) {
      const active = tab.dataset.explorerView === explorerView;
      tab.setAttribute('aria-selected', String(active));
      tab.tabIndex = active ? 0 : -1;
      tab.classList.toggle('active', active);
      tab.parentElement?.classList.toggle('active', active);
      const panelId = tab.getAttribute('aria-controls');
      const panel = panelId ? document.getElementById(panelId) : undefined;
      if (panel) panel.hidden = !active;
    }
    const selectedDocs = docsTabById(explorerView);
    if (selectedDocs && docsAvailable === true) {
      const frame = document.querySelector(`#${selectedDocs.id}-panel iframe`);
      if (frame && !frame.getAttribute('src')) {
        frame.src = `${docsRoot}${selectedDocs.path}`;
      }
    }
    if (focus) {
      elements.explorerTabs.querySelector(
        `[data-explorer-view="${explorerView}"]`
      )?.focus();
    }
    refreshEditors();
    changed();
  }

  function explorerTabKeydown(event) {
    if (!['ArrowLeft', 'ArrowRight', 'Home', 'End']
      .includes(event.key)) return;
    event.preventDefault();
    const tabs = explorerTabButtons();
    const current = tabs.indexOf(event.currentTarget);
    let next = current;
    if (event.key === 'Home') next = 0;
    else if (event.key === 'End') next = tabs.length - 1;
    else if (event.key === 'ArrowLeft') {
      next = (current - 1 + tabs.length) % tabs.length;
    } else {
      next = (current + 1) % tabs.length;
    }
    setExplorerView(tabs[next].dataset.explorerView, true);
  }

  function syncExplorerTabOrder() {
    const available = [
      ...permanentViews,
      ...docsTabs.map((tab) => tab.id),
      ...refTabs.map((tab) => tab.id)
    ];
    explorerOrder = explorerOrder.filter((id) => available.includes(id));
    for (const id of available) {
      if (!explorerOrder.includes(id)) explorerOrder.push(id);
    }
    const wrappers = new Map(
      Array.from(elements.explorerTabs.children).map((wrapper) => {
        return [wrapper.dataset.explorerTabId, wrapper];
      })
    );
    for (const id of explorerOrder) {
      const wrapper = wrappers.get(id);
      if (!wrapper) continue;
      enableTabDrag(wrapper, 'explorer', id);
      elements.explorerTabs.append(wrapper);
    }
  }

  //  A documentation page names itself in its <title>, which repeats the
  //  site and the application.  Drop that noise and keep the leaf.
  function docsTabLabel(documentTitle) {
    const ignored = new Set(['docs', appTitle].filter(Boolean));
    const names = String(documentTitle || '').split(/\s*(?:>|\/)\s*/)
      .map((name) => name.trim())
      .filter((name) => name && !ignored.has(name.toLowerCase()));
    return names.length ? names[names.length - 1] : 'Docs';
  }

  function usefulDocsTitle(title) {
    return docsTabLabel(title) !== 'Docs';
  }

  function syncDocsTab(tab, control, close, frame) {
    const relabel = (title) => {
      tab.title = title;
      control.textContent = docsTabLabel(title);
      control.title = title;
      close.setAttribute('aria-label', `Close ${docsTabLabel(title)}`);
    };
    try {
      const title = frame.contentDocument?.title?.trim();
      const pathname = frame.contentWindow?.location?.pathname || '';
      if (usefulDocsTitle(title)) relabel(title);
      if (pathname.startsWith(docsRoot)) {
        tab.path = pathname.slice(docsRoot.length);
        control.dataset.docPath = tab.path;
      }
      changed();
      const titleNode = frame.contentDocument?.querySelector('title');
      if (titleNode && typeof MutationObserver !== 'undefined') {
        const observer = new MutationObserver(() => {
          const nextTitle = frame.contentDocument?.title?.trim();
          if (!usefulDocsTitle(nextTitle)) return;
          relabel(nextTitle);
          changed();
        });
        observer.observe(titleNode, {
          childList: true, characterData: true, subtree: true
        });
      }
    } catch (_) {
      // The docs frame remains usable if its title cannot be inspected.
    }
  }

  //  Docs and reference tabs share the strip's markup; only the panel
  //  body and the close handler differ.
  function createExplorerTab(tab, variant) {
    const docs = variant === 'docs';
    const label = docs ? docsTabLabel(tab.title) : tab.label;
    const title = docs ? tab.title : tab.label;
    const wrapper = document.createElement('div');
    wrapper.className = docs
      ? 'docs-tab-control' : 'docs-tab-control ref-tab-control';
    wrapper.setAttribute('role', 'presentation');
    wrapper.dataset[docs ? 'docsTab' : 'refTab'] = tab.id;
    wrapper.dataset.explorerTabId = tab.id;
    const control = document.createElement('button');
    control.type = 'button';
    control.className = docs ? 'docs-tab' : 'docs-tab ref-tab';
    control.id = `${tab.id}-tab`;
    control.dataset.explorerView = tab.id;
    if (docs) control.dataset.docPath = tab.path;
    control.setAttribute('role', 'tab');
    control.setAttribute('aria-selected', 'false');
    control.setAttribute('aria-controls', `${tab.id}-panel`);
    control.tabIndex = -1;
    control.textContent = label;
    control.title = title;
    control.addEventListener('click', () => setExplorerView(tab.id));
    control.addEventListener('keydown', explorerTabKeydown);
    const close = document.createElement('button');
    close.type = 'button';
    close.className = docs ? 'docs-tab-close' : 'docs-tab-close ref-tab-close';
    close.setAttribute(
      'aria-label',
      docs ? `Close ${title}` : `Close ${label} reference`
    );
    close.textContent = 'X';
    close.addEventListener('click', () => {
      if (docs) closeDocsTab(tab.id);
      else closeRefTab(tab.id);
    });
    wrapper.append(control, close);
    elements.explorerTabs.append(wrapper);
    const panel = document.createElement('div');
    panel.className = docs
      ? 'explorer-panel docs-explorer-panel'
      : 'explorer-panel ref-explorer-panel';
    panel.id = `${tab.id}-panel`;
    panel.hidden = true;
    panel.setAttribute('role', 'tabpanel');
    panel.setAttribute('aria-labelledby', control.id);
    if (docs) {
      const frame = document.createElement('iframe');
      frame.className = 'docs-explorer-frame';
      frame.title = `${tab.title} documentation`;
      frame.addEventListener('load', () => {
        syncDocsTab(tab, control, close, frame);
      });
      frame.addEventListener('error', disableDocsExplorer);
      panel.append(frame);
    }
    elements.explorerPane.append(panel);
    if (docs) syncExplorerTabOrder();
    else updateRefContent(tab);
  }

  function renderExplorerTabs(variant) {
    //  a consumer without an explorer strip has nothing to render into
    if (!elements.explorerTabs || !elements.explorerPane) return;
    const docs = variant === 'docs';
    const flag = docs ? '[data-docs-tab]' : '[data-ref-tab]';
    const panels = docs ? '.docs-explorer-panel' : '.ref-explorer-panel';
    for (const node of elements.explorerTabs.querySelectorAll(flag)) {
      node.remove();
    }
    for (const node of elements.explorerPane.querySelectorAll(panels)) {
      node.remove();
    }
    for (const tab of docs ? docsTabs : refTabs) {
      createExplorerTab(tab, variant);
    }
    syncExplorerTabOrder();
    if (!docs) updateRefActions();
  }

  function closeExplorerTab(id, variant) {
    const list = variant === 'docs' ? docsTabs : refTabs;
    const index = list.findIndex((tab) => tab.id === id);
    if (index < 0) return undefined;
    const tab = list[index];
    const wasActive = explorerView === id;
    const orderIndex = explorerOrder.indexOf(id);
    document.querySelector(
      `[data-${variant === 'docs' ? 'docs' : 'ref'}-tab="${id}"]`
    )?.remove();
    document.querySelector(`#${id}-panel`)?.remove();
    list.splice(index, 1);
    explorerOrder = explorerOrder.filter((tabId) => tabId !== id);
    if (wasActive) {
      const neighbor = explorerOrder[
        Math.min(orderIndex, explorerOrder.length - 1)
      ];
      setExplorerView(neighbor || '', true);
    }
    return {tab, wasActive};
  }

  function closeDocsTab(id) {
    const closed = closeExplorerTab(id, 'docs');
    if (closed && !closed.wasActive) changed();
  }

  function openDocsTab(title, path) {
    if (docsAvailable !== true) return;
    if (!explorerOpen) setExplorerOpen(true, false);
    const existing = docsTabs.find((tab) => tab.path === path);
    if (existing) {
      setHelpOpen(false);
      setExplorerView(existing.id, true);
      return;
    }
    const tab = {id: `docs-${nextDocs++}`, title, path};
    docsTabs.push(tab);
    explorerOrder.push(tab.id);
    createExplorerTab(tab, 'docs');
    setHelpOpen(false);
    setExplorerView(tab.id, true);
  }

  function updateRefContent(tab) {
    const panel = document.getElementById(`${tab.id}-panel`);
    if (!panel) return;
    const source = document.createElement('pre');
    source.className = 'ref-source';
    source.textContent = tab.source;
    panel.replaceChildren(source);
  }

  function refForParent(name, parentId) {
    return refTabs.find((tab) => {
      return tab.kind === name && tab.parentId === parentId;
    });
  }

  function canAddRef(name, id) {
    const tab = getTab(name, id);
    return Boolean(tab?.source.trim() && !refForParent(name, id));
  }

  function updateRefActions() {
    for (const kind of kinds) {
      if (!kind.refs) continue;
      const control = document.querySelector(`#add-${kind.name}-ref`);
      if (control) control.disabled = !canAddRef(kind.name, activeTabId(kind.name));
    }
  }

  function syncRefFromParent(name, parentId) {
    const ref = refForParent(name, parentId);
    const parent = getTab(name, parentId);
    if (!ref || !parent) return;
    ref.label = parent.label;
    ref.source = parent.source;
    const control = elements.explorerTabs.querySelector(
      `[data-explorer-view="${ref.id}"]`
    );
    if (control) {
      control.textContent = ref.label;
      control.title = ref.label;
      control.parentElement?.querySelector('.ref-tab-close')
        ?.setAttribute('aria-label', `Close ${ref.label} reference`);
    }
    updateRefContent(ref);
    updateRefActions();
  }

  function syncAllRefs() {
    for (const ref of refTabs) syncRefFromParent(ref.kind, ref.parentId);
  }

  function addRef(name, parentId) {
    if (parentId === activeTabId(name)) captureTab(name);
    if (!canAddRef(name, parentId)) return;
    const parent = getTab(name, parentId);
    const tab = {
      id: `ref-${nextRef++}`,
      kind: name,
      parentId,
      label: parent.label,
      source: parent.source
    };
    refTabs.push(tab);
    explorerOrder.push(tab.id);
    createExplorerTab(tab, 'ref');
    syncExplorerTabOrder();
    if (!explorerOpen) setExplorerOpen(true, false);
    setExplorerView(tab.id, true);
    renderTabs(name);
    changed();
  }

  function closeRefTab(id) {
    const closed = closeExplorerTab(id, 'ref');
    if (!closed) return;
    renderTabs(closed.tab.kind);
    changed();
  }

  // ---- documentation ------------------------------------------------
  //
  // Fetches `${config.docsRoot}doc.toc`, an indented `/slug title` list
  // (two-space indent per level, one nesting deep), and renders it as the
  // collapsible nav the help panel's docs tab shows; each leaf opens an
  // iframe at `docsRoot + path`.

  function parseDocsToc(source) {
    const root = [];
    const folders = [];
    for (const line of source.split(/\r?\n/)) {
      const match = line.match(/^(\s*)(\/[^\s]+)(?:\s+(.*\S))?\s*$/);
      if (!match) continue;
      const indentation = match[1].replace(/\t/g, '  ').length;
      if (indentation % 2 !== 0) continue;
      const level = indentation / 2;
      const parts = match[2].slice(1).split('/').filter(Boolean);
      if (parts.length < 1 || parts.length > 2
        || !parts.every((part) => /^[A-Za-z0-9._~-]+$/.test(part))) {
        continue;
      }
      const children = level === 0 ? root : folders[level - 1]?.children;
      if (!children) continue;
      const folder = parts.length === 1;
      const entry = {
        children: folder ? [] : undefined,
        folder,
        slug: parts[0],
        title: match[3] || parts[0]
      };
      children.push(entry);
      folders.length = level;
      if (folder) folders[level] = entry;
    }
    return root;
  }

  function appendDocsEntries(container, entries, parentPath = []) {
    for (const entry of entries) {
      const path = [...parentPath, entry.slug];
      if (entry.folder) {
        const group = document.createElement('details');
        group.className = 'docs-help-group';
        const summary = document.createElement('summary');
        summary.className = 'docs-help-summary';
        summary.textContent = entry.title;
        const subnav = document.createElement('div');
        subnav.className = 'docs-help-subnav';
        appendDocsEntries(subnav, entry.children, path);
        group.append(summary, subnav);
        container.append(group);
        continue;
      }
      const docPath = path.join('/');
      const link = document.createElement('a');
      link.className = 'docs-help-link';
      link.href = `${docsRoot}${docPath}`;
      link.dataset.docPath = docPath;
      link.textContent = entry.title;
      link.addEventListener('click', (event) => {
        event.preventDefault();
        openDocsTab(entry.title, docPath);
      });
      container.append(link);
    }
  }

  async function loadDocsTree() {
    if (docsTreeLoaded) return true;
    try {
      const response = await fetch(`${config.appId.base}/doc.toc`, {
        method: 'GET',
        credentials: 'same-origin',
        cache: 'no-store'
      });
      const contentType = response.headers.get('content-type') || '';
      if (!response.ok || !contentType.includes('text/plain')) return false;
      const entries = parseDocsToc(await response.text());
      if (!entries.length) return false;
      const tree = document.createDocumentFragment();
      appendDocsEntries(tree, entries);
      elements.docsHelpNav.replaceChildren(tree);
      elements.docsHelpNav.setAttribute('aria-busy', 'false');
      docsTreeLoaded = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  function setHelpVariant(useDocs) {
    if (elements.fallbackHelp) elements.fallbackHelp.hidden = useDocs;
    if (elements.docsHelp) elements.docsHelp.hidden = !useDocs;
    if (useDocs && docsTabById(explorerView)) setExplorerView(explorerView);
  }

  function disableDocsExplorer() {
    docsAvailable = false;
    const wasDocs = Boolean(docsTabById(explorerView));
    docsTabs.length = 0;
    renderExplorerTabs('docs');
    if (wasDocs) setExplorerView(explorerOrder[0] || '');
    setHelpVariant(false);
  }

  //  Documentation is optional: the help panel falls back to the
  //  consumer's own content when /docs is not served here.
  async function refreshHelpVariant() {
    if (docsCheckPending || docsAvailable === true) return;
    docsCheckPending = true;
    try {
      const response = await fetch('/docs', {
        method: 'GET',
        credentials: 'same-origin',
        cache: 'no-store'
      });
      const responseUrl = new URL(response.url, window.location.origin);
      const contentType = response.headers.get('content-type') || '';
      const docsPath = responseUrl.pathname === '/docs'
        || responseUrl.pathname.startsWith('/docs/');
      docsAvailable = response.ok
        && responseUrl.origin === window.location.origin && docsPath
        && contentType.includes('text/html');
      if (docsAvailable) docsAvailable = await loadDocsTree();
    } catch (_) {
      docsAvailable = false;
    } finally {
      docsCheckPending = false;
    }
    if (docsAvailable) setHelpVariant(true);
    else disableDocsExplorer();
  }

  // ---- clay file tree and its context menu --------------------------
  //
  // The browse endpoint's flat path list becomes a nested tree, one
  // row per directory or leaf; right-click (or the row's own button)
  // opens the shared context menu, positioned to stay inside the
  // viewport.

  function closeFileContext(restoreFocus = false) {
    elements.contextMenu.hidden = true;
    if (contextTarget.source) {
      contextTarget.source.setAttribute('aria-expanded', 'false');
      if (restoreFocus) contextTarget.source.focus();
    }
    contextTarget = {};
  }

  function openFileContext(name, path, source, event) {
    event.preventDefault();
    event.stopPropagation();
    closeFileContext();
    contextTarget = {kind: name, path, source};
    source.setAttribute('aria-expanded', 'true');
    const menu = elements.contextMenu;
    menu.style.left = '0px';
    menu.style.top = '0px';
    menu.hidden = false;
    const menuRect = menu.getBoundingClientRect();
    const sourceRect = source.getBoundingClientRect();
    const margin = 8;
    const maximumLeft = window.innerWidth - menuRect.width - margin;
    const maximumTop = window.innerHeight - menuRect.height - margin;
    const pointer = event.type === 'contextmenu';
    menu.style.left = `${clamp(
      pointer ? event.clientX : sourceRect.right,
      margin,
      Math.max(margin, maximumLeft)
    )}px`;
    menu.style.top = `${clamp(
      pointer ? event.clientY : sourceRect.top,
      margin,
      Math.max(margin, maximumTop)
    )}px`;
    elements.contextOpen?.focus();
  }

  function fileContextKeydown(event) {
    const items = [elements.contextOpen, elements.contextDelete]
      .filter((item) => item && !item.disabled);
    const current = items.indexOf(document.activeElement);
    let next = current;
    if (event.key === 'Escape') {
      event.preventDefault();
      closeFileContext(true);
      return;
    }
    if (event.key === 'Home') next = 0;
    else if (event.key === 'End') next = items.length - 1;
    else if (event.key === 'ArrowDown') next = (current + 1) % items.length;
    else if (event.key === 'ArrowUp') {
      next = (current - 1 + items.length) % items.length;
    } else {
      return;
    }
    event.preventDefault();
    items[next].focus();
  }

  function normalizeClayPath(value) {
    const path = value.trim().replace(/^\/+/, '');
    if (!path || path.split('/').some((part) => {
      return !part || part === '.' || part === '..';
    })) {
      throw new Error('Enter a relative Clay path');
    }
    if (!/^[A-Za-z0-9._~/-]+$/.test(path)) {
      throw new Error('Clay path contains unsupported characters');
    }
    return path;
  }

  function renderFileTree(paths, name) {
    const tree = treeForKind(name);
    if (!tree) return;
    const root = new Map();
    for (const rawPath of paths) {
      if (typeof rawPath !== 'string') {
        throw new Error('Invalid Clay file list');
      }
      const path = normalizeClayPath(rawPath);
      const parts = path.split('/');
      let branch = root;
      for (const [index, part] of parts.entries()) {
        if (!branch.has(part)) {
          branch.set(part, {children: new Map(), path: undefined});
        }
        const node = branch.get(part);
        if (index === parts.length - 1) node.path = path;
        branch = node.children;
      }
    }
    tree.replaceChildren();
    tree.setAttribute('aria-busy', 'false');
    if (!root.size) {
      tree.textContent = `No /${kindByName.get(name)?.leaf} files found.`;
      return;
    }
    function appendFile(item, label, path) {
      const row = document.createElement('div');
      row.className = 'explorer-file-row';
      row.setAttribute('role', 'treeitem');
      const file = document.createElement('button');
      file.type = 'button';
      file.className = 'file-tree-file';
      file.dataset.path = path;
      file.textContent = label;
      file.title = path;
      file.addEventListener('click', async () => {
        closeFileContext();
        await loadFile(name, path);
      });
      row.addEventListener('contextmenu', (event) => {
        openFileContext(name, path, file, event);
      });
      const actions = document.createElement('button');
      actions.type = 'button';
      actions.className = 'file-tree-actions';
      actions.setAttribute('aria-label', `Actions for ${label}`);
      actions.setAttribute('aria-haspopup', 'menu');
      actions.setAttribute('aria-expanded', 'false');
      actions.textContent = '…';
      actions.addEventListener('click', (event) => {
        openFileContext(name, path, actions, event);
      });
      row.append(file, actions);
      item.append(row);
    }
    //  A directory holding exactly one leaf file is shown as one row:
    //  `left/txt` reads as a file, not as a folder with one child.
    function renderBranch(branch) {
      const list = document.createElement('ul');
      list.className = 'file-tree-list';
      const entries = [...branch.entries()]
        .sort(([left], [right]) => left.localeCompare(right));
      for (const [part, node] of entries) {
        const item = document.createElement('li');
        const children = [...node.children.entries()];
        const suffix = children.length === 1 ? children[0] : undefined;
        if (!node.path && suffix && suffix[1].path
          && !suffix[1].children.size) {
          appendFile(item, `${part}/${suffix[0]}`, suffix[1].path);
          list.append(item);
          continue;
        }
        if (node.children.size) {
          const directory = document.createElement('div');
          directory.className = 'file-tree-directory';
          directory.textContent = `${part}/`;
          item.append(directory);
        }
        if (node.path) appendFile(item, part, node.path);
        if (node.children.size) item.append(renderBranch(node.children));
        list.append(item);
      }
      return list;
    }
    tree.append(renderBranch(root));
  }

  async function refreshFileTree(name) {
    const tree = treeForKind(name);
    if (!tree) return;
    tree.replaceChildren();
    tree.textContent = 'Loading…';
    tree.setAttribute('aria-busy', 'true');
    try {
      renderFileTree(await browseClayNode(name), name);
    } catch (cause) {
      tree.setAttribute('aria-busy', 'false');
      tree.replaceChildren();
      tree.textContent = `Unable to load files: ${String(cause)}`;
      showError(cause);
    }
  }

  function showFileExplorer(name) {
    if (!explorerOpen) setExplorerOpen(true, false);
    setExplorerView(viewForKind(name), true);
    refreshFileTree(name);
  }


  // ---- persistence --------------------------------------------------
  //
  // One localStorage record under `config.appId.storageKey`, described
  // slot by slot by `config.slots`.  Each slot names the json key as it
  // already appears on disk, so an existing record keeps loading with no
  // migration.  urui owns the shell's slots; a slot marked `app` is read
  // and written through `options.session`.
  const storageKey = config.appId?.storageKey;
  const storageVersion = config.appId?.storageVersion ?? 1;
  const slots = config.slots || [];
  const maxSource = limits.maxSource ?? 262144;
  const share = config.shareParam;
  let saveTimer;

  function sourceByteLength(source) {
    return new TextEncoder().encode(source).byteLength;
  }

  function validateSource(source, limit = maxSource) {
    if (typeof source !== 'string') throw new Error('Source must be text');
    if (source.includes('\0')) throw new Error('Source contains a null byte');
    if (sourceByteLength(source) > limit) {
      throw new Error(`Source exceeds the ${limit}-byte limit`);
    }
    return source;
  }

  function validSavedSource(source) {
    try {
      return validateSource(source);
    } catch (_) {
      return undefined;
    }
  }

  function validTabPath(path) {
    if (path === undefined) return undefined;
    if (typeof path !== 'string' || path.length > 1_024) return undefined;
    try {
      return normalizeClayPath(path);
    } catch (_) {
      return undefined;
    }
  }

  function validTabLabel(label, fallback) {
    return typeof label === 'string' && label.trim() && label.length <= 200
      ? label.trim()
      : fallback;
  }

  function idPattern(prefix) {
    return new RegExp(`^${prefix}-[1-9][0-9]*$`);
  }

  //  A saved id carries its own counter: `dot-7` means the next tab is
  //  at least 8, however stale the saved counter is.
  function highestId(tabs) {
    return tabs.reduce((highest, tab) => {
      return Math.max(highest, Number(tab.id.split('-').pop()) + 1);
    }, 1);
  }

  function validDocumentTab(candidate, name, seen) {
    if (!candidate || typeof candidate !== 'object') return undefined;
    if (!idPattern(name).test(candidate.id)) return undefined;
    const source = validSavedSource(candidate.source);
    if (source === undefined) return undefined;
    const path = validTabPath(candidate.path);
    const base = {
      id: candidate.id,
      label: validTabLabel(candidate.label, tabLabel(name, path)),
      path,
      source,
      cleanSource: validSavedSource(candidate.cleanSource) ?? source
    };
    const extra = tabHooks(name).validate?.(candidate, base, seen);
    if (extra === false) return undefined;
    return {...base, ...(extra || {})};
  }

  function validDocsTab(candidate) {
    if (!candidate || typeof candidate !== 'object') return undefined;
    if (!idPattern('docs').test(candidate.id)) return undefined;
    if (typeof candidate.title !== 'string' || !candidate.title.trim()
      || candidate.title.length > 200) return undefined;
    if (typeof candidate.path !== 'string' || !candidate.path
      || candidate.path.length > 1_024
      || candidate.path.startsWith('/')
      || candidate.path.split('/').some((part) => {
        return !part || part === '.' || part === '..';
      })) return undefined;
    return {
      id: candidate.id,
      title: candidate.title.trim(),
      path: candidate.path
    };
  }

  function validRefTab(candidate) {
    if (!candidate || typeof candidate !== 'object') return undefined;
    if (!idPattern('ref').test(candidate.id)) return undefined;
    if (!stores.has(candidate.kind)) return undefined;
    if (!idPattern(candidate.kind).test(candidate.parentId)) return undefined;
    const source = validSavedSource(candidate.source);
    if (source === undefined) return undefined;
    return {
      id: candidate.id,
      kind: candidate.kind,
      parentId: candidate.parentId,
      label: validTabLabel(candidate.label, 'Reference'),
      source
    };
  }

  //  `preferences.theme` is one slot naming a nested json key
  function readEnvelope(saved, key) {
    return key.split('.').reduce((node, part) => {
      return node === undefined || node === null ? undefined : node[part];
    }, saved);
  }

  function writeEnvelope(record, key, value) {
    const parts = key.split('.');
    const leaf = parts.pop();
    let node = record;
    for (const part of parts) {
      if (!node[part]) node[part] = {};
      node = node[part];
    }
    node[leaf] = value;
  }

  //  What urui writes for its own slots, by key and by shape.
  function readSlot(slot) {
    if (slot.owner === 'app') return options.session?.read?.(slot.key);
    if (slot.kind) {
      if (slot.shape === 'tabs') return tabList(slot.kind);
      if (slot.shape === 'active') return activeTabId(slot.kind);
      if (slot.shape === 'next') return store(slot.kind).next;
      return undefined;
    }
    switch (slot.key) {
      case 'paneWidth': return paneWidth();
      case 'explorerWidth': return explorerWidth();
      case 'explorerOpen': return explorerOpen;
      case 'explorerView': return explorerView;
      case 'explorerOrder': return explorerOrder;
      case 'docsTabs': return docsTabs;
      case 'nextDocs': return nextDocs;
      case 'refTabs': return refTabs;
      case 'nextRef': return nextRef;
      case 'preferences.theme': return selectedTheme();
      default: return undefined;
    }
  }

  function saveSession() {
    clearTimeout(saveTimer);
    try {
      for (const kind of kinds) captureTab(kind.name);
      const record = {version: storageVersion};
      for (const slot of slots) {
        writeEnvelope(record, slot.key, readSlot(slot));
      }
      localStorage.setItem(storageKey, JSON.stringify(record));
    } catch (_) {
      // Storage can be disabled or full without blocking the editor.
    }
  }

  function queueSaveSession() {
    clearTimeout(saveTimer);
    saveTimer = setTimeout(saveSession, limits.saveDebounce ?? 150);
  }

  //  Validate the whole record, then apply urui's half of it.  The
  //  consumer gets the record back and reads only its own slots.
  function loadSession() {
    let saved;
    try {
      saved = JSON.parse(localStorage.getItem(storageKey));
    } catch (_) {
      return undefined;
    }
    if (!saved || saved.version !== storageVersion) return undefined;
    const record = {};
    const acceptedIds = new Map();

    //  documents first: references and the active id point at them
    for (const slot of slots) {
      if (slot.owner !== 'urui' || slot.shape !== 'tabs' || !slot.kind) {
        continue;
      }
      const seenIds = new Set();
      const seenPaths = new Set();
      const raw = readEnvelope(saved, slot.key);
      const tabs = Array.isArray(raw)
        ? raw.map((candidate) => {
          return validDocumentTab(candidate, slot.kind, acceptedIds);
        }).filter((tab) => {
          if (!tab || seenIds.has(tab.id)) return false;
          if (tab.path && seenPaths.has(tab.path)) return false;
          seenIds.add(tab.id);
          if (tab.path) seenPaths.add(tab.path);
          return true;
        })
        : [];
      acceptedIds.set(slot.kind, seenIds);
      record[slot.key] = tabs;
    }

    const docsSlot = slots.find((slot) => {
      return slot.owner === 'urui' && slot.shape === 'tabs' && !slot.kind
        && slot.key === 'docsTabs';
    });
    let savedDocsTabs = [];
    if (docsSlot) {
      const seenIds = new Set();
      const seenPaths = new Set();
      const raw = readEnvelope(saved, docsSlot.key);
      savedDocsTabs = Array.isArray(raw)
        ? raw.map(validDocsTab).filter((tab) => {
          if (!tab || seenIds.has(tab.id) || seenPaths.has(tab.path)) {
            return false;
          }
          seenIds.add(tab.id);
          seenPaths.add(tab.path);
          return true;
        })
        : [];
      record[docsSlot.key] = savedDocsTabs;
    }

    const refsSlot = slots.find((slot) => {
      return slot.owner === 'urui' && slot.shape === 'tabs' && !slot.kind
        && slot.key === 'refTabs';
    });
    let savedRefTabs = [];
    if (refsSlot) {
      const seenIds = new Set();
      const seenParents = new Set();
      const raw = readEnvelope(saved, refsSlot.key);
      savedRefTabs = Array.isArray(raw)
        ? raw.map(validRefTab).filter((tab) => {
          if (!tab || seenIds.has(tab.id)) return false;
          const parentKey = `${tab.kind}:${tab.parentId}`;
          if (seenParents.has(parentKey)) return false;
          seenIds.add(tab.id);
          seenParents.add(parentKey);
          return true;
        })
        : [];
      record[refsSlot.key] = savedRefTabs;
    }

    //  the strip can hold every permanent view plus what survived
    const availableViews = [
      ...permanentViews,
      ...savedDocsTabs.map((tab) => tab.id),
      ...savedRefTabs.map((tab) => tab.id)
    ];

    for (const slot of slots) {
      if (record[slot.key] !== undefined) continue;
      const raw = readEnvelope(saved, slot.key);
      if (slot.owner === 'app') {
        record[slot.key] = options.session?.validate?.(slot.key, raw);
        continue;
      }
      if (slot.kind && slot.shape === 'active') {
        const ids = acceptedIds.get(slot.kind);
        const tabs = record[tabsKeyFor(slot.kind)] || [];
        record[slot.key] = ids?.has(raw) ? raw : tabs[0]?.id;
        continue;
      }
      if (slot.shape === 'next') {
        const tabs = slot.kind
          ? record[tabsKeyFor(slot.kind)] || []
          : (slot.key === 'nextDocs' ? savedDocsTabs : savedRefTabs);
        const floor = highestId(tabs);
        const value = Number(raw);
        record[slot.key] = Number.isSafeInteger(value)
          ? Math.max(value, floor)
          : floor;
        continue;
      }
      switch (slot.key) {
        case 'paneWidth': {
          const value = Number(raw);
          record[slot.key] = Number.isFinite(value)
            ? clamp(value, paneMin, paneMax)
            : 44;
          break;
        }
        case 'explorerWidth': {
          const value = Number(raw);
          record[slot.key] = Number.isFinite(value)
            ? Math.max(value, minExplorer)
            : 288;
          break;
        }
        case 'explorerOpen':
          record[slot.key] = raw !== false;
          break;
        case 'explorerView':
          record[slot.key] = typeof raw === 'string'
            && availableViews.includes(raw) ? raw : firstView;
          break;
        case 'explorerOrder': {
          const order = Array.isArray(raw)
            ? raw.filter((id, index, items) => {
              return typeof id === 'string' && availableViews.includes(id)
                && items.indexOf(id) === index;
            })
            : [];
          for (const id of availableViews) {
            if (!order.includes(id)) order.push(id);
          }
          record[slot.key] = order;
          break;
        }
        case 'preferences.theme':
          record[slot.key] = validTheme(raw);
          break;
        default:
          record[slot.key] = raw;
      }
    }

    applySession(record);
    return record;
  }

  function tabsKeyFor(name) {
    return slots.find((slot) => {
      return slot.kind === name && slot.shape === 'tabs';
    })?.key;
  }

  //  Apply urui's slots without persisting: this is a restore, not an
  //  edit, and writing here would race the record being read.
  function applySession(record) {
    for (const slot of slots) {
      if (slot.owner !== 'urui') continue;
      const value = record[slot.key];
      if (value === undefined) continue;
      if (slot.kind) {
        if (slot.shape === 'tabs') {
          const tabs = tabList(slot.kind);
          tabs.splice(0, tabs.length, ...value);
        } else if (slot.shape === 'active') {
          store(slot.kind).activeId = value;
        } else if (slot.shape === 'next') {
          store(slot.kind).next = value;
        }
        continue;
      }
      switch (slot.key) {
        case 'paneWidth': setPaneWidth(value, false); break;
        case 'explorerWidth': setExplorerWidth(value); break;
        case 'explorerOpen': setExplorerOpen(value, false); break;
        case 'explorerOrder': explorerOrder = value; break;
        case 'docsTabs': docsTabs.splice(0, docsTabs.length, ...value); break;
        case 'nextDocs': nextDocs = value; break;
        case 'refTabs': refTabs.splice(0, refTabs.length, ...value); break;
        case 'nextRef': nextRef = value; break;
        case 'preferences.theme': applyTheme(value, false); break;
        default: break;
      }
    }
  }

  // ---- shared source in the url -------------------------------------
  //
  // `config.shareParam` names a url query parameter that carries one
  // document's source, base64url-encoded, for an app that supports
  // sharing a link. `decodeSource` refuses when `config.shareParam` is
  // absent, oversized, or does not round-trip.

  function encodeSource(source) {
    const bytes = new TextEncoder().encode(source);
    let binary = '';
    for (const byte of bytes) binary += String.fromCharCode(byte);
    return btoa(binary)
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=+$/g, '');
  }

  //  A shared link must round-trip exactly: anything that re-encodes
  //  differently is a mangled or hand-edited parameter, not a source.
  function decodeSource(encoded) {
    if (!share) throw new Error('This application does not share sources');
    if (!encoded || encoded.length > share.paramMax) {
      throw new Error(`Shared ${share.name} parameter is missing or too large`);
    }
    if (!/^[A-Za-z0-9_-]+$/.test(encoded)) {
      throw new Error(`Shared ${share.name} parameter is invalid`);
    }
    const base64 = encoded.replace(/-/g, '+').replace(/_/g, '/');
    const padded = base64 + '='.repeat((4 - base64.length % 4) % 4);
    const binary = atob(padded);
    const bytes = Uint8Array.from(binary, (char) => char.charCodeAt(0));
    const source = new TextDecoder('utf-8', {fatal: true}).decode(bytes);
    validateSource(source, share.max);
    if (encodeSource(source) !== encoded) {
      throw new Error(`Shared ${share.name} parameter is not canonical`);
    }
    return source;
  }

  function sourceFromUrl() {
    if (!share) return undefined;
    const encoded = new URL(window.location.href)
      .searchParams.get(share.name);
    return encoded === null ? undefined : decodeSource(encoded);
  }

  '''
  files
  shortcuts
  '''
  // Everything above is callable on its own; `wire` is what turns the
  // frame into a live surface.  A consumer that wants different
  // behavior simply does not call it.
  function wire() {
    document.addEventListener('keydown', dispatchShortcut, {capture: true});
    for (const {name} of kinds) {
      for (const [action, handler] of Object.entries({
        browse: showFileExplorer, load: loadFile, save: saveFile
      })) {
        document.querySelector(`#${action}-${name}`)
          ?.addEventListener('click', () => handler(name));
      }
    }
    elements.contextOpen?.addEventListener('click', () => {
      const {kind, path} = contextTarget;
      closeFileContext();
      if (kind && path) loadFile(kind, path);
    });
    elements.contextDelete?.addEventListener('click', () => {
      const {kind, path, source} = contextTarget;
      closeFileContext();
      if (kind && path) deleteFile(kind, path, source);
    });
    elements.themeControl?.addEventListener('change', () => {
      applyTheme(elements.themeControl.value);
    });
    if (themeMedia.addEventListener) {
      themeMedia.addEventListener('change', systemThemeChanged);
    } else {
      themeMedia.addListener(systemThemeChanged);
    }
    elements.helpToggle?.addEventListener('click', () => setHelpOpen(true));
    elements.closeHelp?.addEventListener('click', () => {
      setHelpOpen(false, true);
    });
    elements.helpPanel?.addEventListener('click', (event) => {
      if (event.target === elements.helpPanel) setHelpOpen(false, true);
    });
    elements.closeError?.addEventListener('click', hideError);
    elements.errorModal?.addEventListener('click', (event) => {
      if (event.target === elements.errorModal) hideError();
    });
    elements.explorerCollapse?.addEventListener('click', () => {
      setExplorerOpen(!explorerOpen);
    });
    elements.explorerResizer?.addEventListener('pointerdown', (event) => {
      if (narrowMedia.matches) return;
      elements.explorerResizer.setPointerCapture(event.pointerId);
    });
    elements.explorerResizer?.addEventListener('pointermove', (event) => {
      if (!elements.explorerResizer.hasPointerCapture(event.pointerId)) return;
      const bounds = elements.workbench.getBoundingClientRect();
      setExplorerWidth(event.clientX - bounds.left, true);
    });
    elements.explorerResizer?.addEventListener('keydown', (event) => {
      if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
      event.preventDefault();
      const change = event.key === 'ArrowLeft' ? -16 : 16;
      setExplorerWidth(explorerWidth() + change, true);
    });
    elements.splitter?.addEventListener('pointerdown', (event) => {
      if (narrowMedia.matches) return;
      elements.splitter.setPointerCapture(event.pointerId);
    });
    elements.splitter?.addEventListener('pointermove', (event) => {
      if (!elements.splitter.hasPointerCapture(event.pointerId)) return;
      const bounds = elements.workspace.getBoundingClientRect();
      setPaneWidth(((event.clientX - bounds.left) / bounds.width) * 100);
    });
    elements.splitter?.addEventListener('keydown', (event) => {
      if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
      event.preventDefault();
      setPaneWidth(paneWidth() + (event.key === 'ArrowLeft' ? -2 : 2));
    });
    for (const name of permanentViews) {
      const tab = document.querySelector(`#${name}-tab`);
      if (!tab) continue;
      tab.addEventListener('click', () => {
        setExplorerView(tab.dataset.explorerView);
      });
      tab.addEventListener('keydown', explorerTabKeydown);
    }
    elements.contextMenu?.addEventListener('keydown', fileContextKeydown);
    //  a reference is created by dropping a document tab on the aside
    elements.explorerPane?.addEventListener('dragover', (event) => {
      if (!draggedTab || !stores.has(draggedTab.kind)
        || !canAddRef(draggedTab.kind, draggedTab.id)) return;
      event.preventDefault();
      if (event.dataTransfer) event.dataTransfer.dropEffect = 'copy';
    });
    elements.explorerPane?.addEventListener('drop', (event) => {
      if (!draggedTab || !stores.has(draggedTab.kind)
        || !canAddRef(draggedTab.kind, draggedTab.id)) return;
      event.preventDefault();
      event.stopPropagation?.();
      addRef(draggedTab.kind, draggedTab.id);
    });
    document.addEventListener('click', (event) => {
      const menu = elements.contextMenu;
      if (!menu || menu.hidden || menu.contains(event.target)) return;
      if (contextTarget.source?.parentElement?.contains(event.target)) return;
      closeFileContext();
    });
    window.addEventListener('beforeunload', saveSession);
    window.addEventListener('resize', () => {
      closeFileContext();
      options.onResize?.();
      refreshEditors();
    });
  }

  return {
    elements,
    clamp,
    refreshEditors,
    files: {
      browse: refreshFileTree, load: loadFile, save: saveFile,
      delete: deleteFile
    },
    shortcuts: {register: registerShortcut, dispatch: dispatchShortcut},
    tabs: {
      kinds,
      kind: (name) => kindByName.get(name),
      list: tabList,
      active: activeTab,
      activeId: activeTabId,
      setActiveId: (name, id) => { store(name).activeId = id; },
      setList: (name, list) => {
        const tabs = tabList(name);
        tabs.splice(0, tabs.length, ...list);
      },
      next: (name) => store(name).next,
      setNext: (name, value) => { store(name).next = value; },
      get: getTab,
      label: tabLabel,
      dirty: tabDirty,
      create: createTab,
      addEmpty: addEmptyTab,
      capture: captureTab,
      select: selectTab,
      close: closeTab,
      render: renderTabs,
      move: moveTab,
      container: tabContainer,
      focus: focusTab,
      enableDrag: enableTabDrag,
      dragged: () => draggedTab,
      clearDragged: () => { draggedTab = undefined; }
    },
    theme: {
      valid: validTheme,
      selected: selectedTheme,
      apply: applyTheme,
      media: themeMedia,
      systemChanged: systemThemeChanged
    },
    status: {set: setStatus, node: statusNode},
    layout: {
      paneWidth,
      setPaneWidth,
      explorerWidth,
      setExplorerWidth,
      maxExplorerWidth,
      explorerOpen: () => explorerOpen,
      setExplorerOpen,
      apply: applyExplorerLayout
    },
    explorer: {
      view: () => explorerView,
      setView: setExplorerView,
      validView: validExplorerView,
      order: () => explorerOrder,
      setOrder: (list) => { explorerOrder = list; },
      syncOrder: syncExplorerTabOrder,
      tabKeydown: explorerTabKeydown,
      buttons: explorerTabButtons,
      docs: {
        list: () => docsTabs,
        //  in place, like the document stores: a consumer may hold it
        setList: (list) => { docsTabs.splice(0, docsTabs.length, ...list); },
        next: () => nextDocs,
        setNext: (value) => { nextDocs = value; },
        byId: docsTabById,
        render: () => renderExplorerTabs('docs'),
        open: openDocsTab,
        close: closeDocsTab,
        label: docsTabLabel,
        parseToc: parseDocsToc,
        available: () => docsAvailable,
        refreshVariant: refreshHelpVariant,
        setVariant: setHelpVariant,
        disable: disableDocsExplorer
      },
      refs: {
        list: () => refTabs,
        setList: (list) => { refTabs.splice(0, refTabs.length, ...list); },
        next: () => nextRef,
        setNext: (value) => { nextRef = value; },
        byId: refTabById,
        render: () => renderExplorerTabs('ref'),
        add: addRef,
        close: closeRefTab,
        can: canAddRef,
        forParent: refForParent,
        syncFromParent: syncRefFromParent,
        syncAll: syncAllRefs,
        updateActions: updateRefActions
      },
      tree: {
        render: renderFileTree,
        refresh: refreshFileTree,
        show: showFileExplorer,
        normalize: normalizeClayPath,
        node: treeForKind
      },
      context: {
        open: openFileContext,
        close: closeFileContext,
        keydown: fileContextKeydown,
        target: () => contextTarget
      }
    },
    session: {
      key: storageKey,
      version: storageVersion,
      load: loadSession,
      save: saveSession,
      queue: queueSaveSession,
      validateSource,
      byteLength: sourceByteLength,
      sourceFromUrl,
      encodeSource,
      decodeSource
    },
    dialogs: {
      helpIsOpen,
      setHelpOpen,
      showError,
      hideError,
      errorIsOpen
    },
    wire
  };
  '''
  ==
::
++  files
  ::  Clay operations in the runtime scope; per-kind hooks supply policy.
  ^-  @t
  '''
  // ---- Clay files ---------------------------------------------------
  // Per-kind hooks only supply document policy and application feedback:
  // validate(source), canSave(tab), status(label, action), loaded(tab),
  // saved(tab, source), error(cause, action). Tabs and requests stay here.
  const endpoints = config.endpoints || {};
  const fileHooks = (name) => options.files?.[name] || {};

  function fileStatus(name, label, action) {
    const hook = fileHooks(name).status;
    if (hook) hook(label, action);
    else setStatus(kinds[0]?.name === name ? 'editor' : 'result', label);
  }

  function requestClayPath(name) {
    const value = window.prompt(`${kindByName.get(name).label} path`);
    return value === null ? undefined : normalizeClayPath(value);
  }

  async function clayFileRequest(
    name, action, source = '', requestedPath, overwrite = false
  ) {
    store(name);
    const path = requestedPath === undefined
      ? requestClayPath(name)
      : action === 'browse' && requestedPath === ''
        ? '' : normalizeClayPath(requestedPath);
    if (path === undefined) return undefined;
    const route = endpoints[action];
    if (!route) throw new Error(`Missing Clay endpoint: ${action}`);
    const headers = {};
    const request = {method: 'POST', headers};
    if (endpoints.transport === 'body') {
      headers['content-type'] = 'application/json';
      request.body = JSON.stringify({
        path: path ? path.split('/') : [], source, overwrite
      });
    } else {
      if (action !== 'browse') {
        headers['content-type'] = 'text/plain; charset=utf-8';
        request.body = source;
      }
      if (path || action !== 'browse') headers[endpoints.pathHeader] = path;
      if (overwrite) headers[endpoints.flagHeader] = 'true';
    }
    const response = await fetch(route.replaceAll('{kind}', name), request);
    const body = await response.text();
    if (action === 'save' && response.status === 409 && !overwrite) {
      const label = kindByName.get(name).label;
      if (!window.confirm(
        `${label} path "${path}" already exists. Overwrite it?`
      )) return undefined;
      return clayFileRequest(name, action, source, path, true);
    }
    if (!response.ok) {
      throw new Error(body || `Clay request failed (${response.status})`);
    }
    return body;
  }

  async function browseClayNode(name, path = '') {
    const node = JSON.parse(await clayFileRequest(name, 'browse', '', path));
    if (!node || typeof node.file !== 'boolean'
      || !Array.isArray(node.children)) {
      throw new Error('Invalid Clay directory');
    }
    const paths = node.file ? [path] : [];
    for (const child of node.children) {
      if (typeof child !== 'string' || !child || child.includes('/')) {
        throw new Error('Invalid Clay directory');
      }
      const next = normalizeClayPath(path ? `${path}/${child}` : child);
      paths.push(...await browseClayNode(name, next));
    }
    return paths;
  }

  async function loadFile(name, path) {
    const hooks = fileHooks(name);
    try {
      const requested = path == null
        ? requestClayPath(name) : normalizeClayPath(path);
      if (requested === undefined) return;
      const existing = tabList(name).find((tab) => tab.path === requested);
      if (existing) {
        selectTab(name, existing.id, {focus: true});
        return existing;
      }
      fileStatus(name, 'Loading', 'load');
      const source = await clayFileRequest(name, 'load', '', requested);
      validateSource(source);
      hooks.validate?.(source);
      const tab = createTab(name, source, {path: requested});
      selectTab(name, tab.id, {focus: true});
      hooks.loaded?.(tab);
      fileStatus(name, 'Ready', 'load');
      return tab;
    } catch (cause) {
      showError(cause);
      fileStatus(name, 'Load failed', 'load');
      hooks.error?.(cause, 'load');
    }
  }

  async function saveFile(name) {
    const hooks = fileHooks(name);
    try {
      const tab = captureTab(name);
      if (!tab || hooks.canSave?.(tab) === false) return;
      const source = validateSource(tab.source);
      hooks.validate?.(source);
      const path = tab.path ?? requestClayPath(name);
      if (path === undefined) return;
      if (tab.path) {
        let stored;
        try {
          stored = await clayFileRequest(name, 'load', '', path);
        } catch (_) {
          // A missing stored copy must not prevent recreating the file.
        }
        if (stored !== undefined && stored !== tab.cleanSource
          && !window.confirm(
            `${path} changed in Clay since it was loaded. Overwrite it?`
          )) {
          fileStatus(name, 'Ready', 'save');
          return;
        }
      }
      fileStatus(name, 'Saving', 'save');
      const result = await clayFileRequest(
        name, 'save', source, path, Boolean(tab.path)
      );
      fileStatus(name, result === undefined ? 'Ready' : 'Saved', 'save');
      if (result === undefined) return;
      tab.path = path;
      tab.label = tabLabel(name, path);
      tab.cleanSource = source;
      hooks.saved?.(tab, source);
      syncRefFromParent(name, tab.id);
      renderTabs(name);
      changed();
      await refreshFileTree(name);
      return result;
    } catch (cause) {
      showError(cause);
      fileStatus(name, 'Save failed', 'save');
      hooks.error?.(cause, 'save');
    }
  }

  async function deleteFile(name, requestedPath, returnFocus) {
    try {
      const path = requestedPath == null
        ? requestClayPath(name) : normalizeClayPath(requestedPath);
      if (path === undefined) return;
      if (!window.confirm(`Delete ${path}? This cannot be undone.`)) {
        returnFocus?.focus();
        return;
      }
      const result = await clayFileRequest(name, 'delete', '', path);
      await refreshFileTree(name);
      fileStatus(name, `${path} deleted`, 'delete');
      return result;
    } catch (cause) {
      showError(cause);
      fileHooks(name).error?.(cause, 'delete');
    }
  }
  '''
::
++  shortcuts
  ::  Capture app chords before Ace, preserving unclaimed editor keys.
  ^-  @t
  '''
  // ---- shortcuts ----------------------------------------------------
  // `preview` is consumer-defined availability, independent of Ace focus.
  // Other contexts use editor focus. Unclaimed non-editor keys can reach
  // onKeydown; returning true consumes a consumer's contextual action.
  const shortcutCommands = new Map();

  function registerShortcut(command, handler) {
    if (typeof handler !== 'function') {
      throw new TypeError('Shortcut handler must be a function');
    }
    shortcutCommands.set(command, handler);
  }

  function dispatchShortcut(event) {
    const consume = () => {
      event.preventDefault();
      event.stopPropagation?.();
    };
    if (event.key === 'Escape') {
      if (helpIsOpen()) {
        consume();
        setHelpOpen(false, true);
        return;
      }
      if (errorIsOpen()) {
        consume();
        hideError();
        return;
      }
      if (elements.contextMenu && !elements.contextMenu.hidden) {
        consume();
        closeFileContext(true);
        return;
      }
    }
    const target = event.target || document.activeElement;
    const inEditor = editors().some((editor) => editor.isFocused?.(target));
    const contexts = {
      always: true,
      editor: inEditor,
      'no-editor': !inEditor,
      preview: options.shortcuts?.preview?.(event) ?? false
    };
    for (const shortcut of config.shortcuts || []) {
      if (!contexts[shortcut.when]) continue;
      const parts = shortcut.binding.toLowerCase().split('-');
      const key = parts.pop();
      const primary = parts.includes('ctrl') || parts.includes('meta');
      if (event.key.toLowerCase() !== key
        || Boolean(event.ctrlKey || event.metaKey) !== primary
        || Boolean(event.shiftKey) !== parts.includes('shift')
        || Boolean(event.altKey) !== parts.includes('alt')) continue;
      const handler = shortcutCommands.get(shortcut.command);
      if (!handler) continue;
      consume();
      handler(event);
      return;
    }
    if (inEditor) return;
    if (options.shortcuts?.onKeydown?.(event) === true) consume();
  }
  '''
::
++  editor-adapter
  ::  The body of createAceEditorAdapter, shared by every consumer.
  ::
  ^-  @t
  '''
  const assets = options.assets;
  if (!window.ace || !assets) {
    throw new Error('Ace runtime or configuration did not load');
  }
  const AceRange = window.ace.require('ace/range').Range;
  const beautify = window.ace.require('ace/ext/beautify');
  if (!Array.isArray(beautify?.commands)) {
    throw new Error('Ace Beautify extension did not load');
  }
  const aceEditor = window.ace.edit(host);
  const session = aceEditor.session;
  const changeListeners = new Set();
  const textInput = aceEditor.textInput.getElement();
  let errorMarker;
  let suppressChanges = 0;

  aceEditor.setOptions({
    displayIndentGuides: true,
    fontSize: '0.9rem',
    highlightActiveLine: true,
    showPrintMargin: false,
    tabSize: 2,
    useSoftTabs: true,
    wrap: true
  });
  aceEditor.setTheme(
    document.documentElement.dataset.effectiveTheme === 'dark'
      ? assets.darkTheme
      : assets.lightTheme
  );
  session.setMode(options.mode || assets.mode);
  session.setUseWorker(assets.useWorker);
  if (options.platform) {
    aceEditor.commands.platform = options.platform;
  }
  aceEditor.commands.addCommands(beautify.commands);
  aceEditor.commands.bindKey('Ctrl-T', 'transposeletters');
  textInput.setAttribute(
    'aria-label',
    options.label || 'Source editor'
  );
  if (options.labelledBy) {
    textInput.setAttribute('aria-labelledby', options.labelledBy);
  }
  textInput.setAttribute(
    'aria-describedby',
    options.describedBy || ''
  );
  textInput.setAttribute('aria-invalid', 'false');

  function getSource() {
    return aceEditor.getValue();
  }

  function clampOffset(offset) {
    const numeric = Number.isFinite(offset) ? Math.trunc(offset) : 0;
    return Math.max(0, Math.min(getSource().length, numeric));
  }

  function getSelection() {
    const range = aceEditor.selection.getRange();
    return {
      start: positionToOffset(range.start),
      end: positionToOffset(range.end)
    };
  }

  function setSelection(start, end = start) {
    const nextStart = clampOffset(start);
    const nextEnd = Math.max(nextStart, clampOffset(end));
    const first = offsetToPosition(nextStart);
    const last = offsetToPosition(nextEnd);
    aceEditor.selection.setSelectionRange(new AceRange(
      first.row,
      first.column,
      last.row,
      last.column
    ));
  }

  function offsetToPosition(offset) {
    return session.doc.indexToPosition(clampOffset(offset), 0);
  }

  function positionToOffset(position) {
    const source = getSource();
    const lines = source.split('\n');
    const requestedRow = Number.isFinite(position?.row)
      ? Math.trunc(position.row)
      : 0;
    const row = Math.max(0, Math.min(lines.length - 1, requestedRow));
    const requestedColumn = Number.isFinite(position?.column)
      ? Math.trunc(position.column)
      : 0;
    const column = Math.max(0, Math.min(lines[row].length, requestedColumn));
    return session.doc.positionToIndex({row, column}, 0);
  }

  function notifyChange() {
    for (const listener of changeListeners) listener();
  }

  function mutate(change, notify) {
    suppressChanges += 1;
    try {
      change();
    } finally {
      suppressChanges -= 1;
    }
    if (notify !== false) notifyChange();
  }

  function isolateUndo(change) {
    const undoManager = session.getUndoManager();
    undoManager.startNewGroup();
    try {
      change();
    } finally {
      undoManager.startNewGroup();
    }
  }

  function setSource(source, options = {}) {
    mutate(() => {
      const history = options.history || 'undoable';
      if (history === 'reset') {
        session.setValue(source);
        session.getUndoManager().reset();
      } else if (history === 'undoable') {
        const last = offsetToPosition(getSource().length);
        isolateUndo(() => {
          session.replace(new AceRange(
            0,
            0,
            last.row,
            last.column
          ), source);
        });
      } else {
        throw new Error(`Unsupported editor history mode: ${history}`);
      }
      const selection = options.selection || {
        start: source.length,
        end: source.length
      };
      setSelection(selection.start, selection.end);
    }, options.notify);
  }

  function replaceRange(start, end, replacement, options = {}) {
    const rangeStart = clampOffset(start);
    const rangeEnd = Math.max(rangeStart, clampOffset(end));
    const first = offsetToPosition(rangeStart);
    const last = offsetToPosition(rangeEnd);
    mutate(() => {
      isolateUndo(() => {
        session.replace(new AceRange(
          first.row,
          first.column,
          last.row,
          last.column
        ), replacement);
      });
      const replacementEnd = rangeStart + replacement.length;
      if (options.selection && typeof options.selection === 'object') {
        setSelection(options.selection.start, options.selection.end);
      } else if (options.selection === 'select') {
        setSelection(rangeStart, replacementEnd);
      } else if (options.selection === 'start') {
        setSelection(rangeStart);
      } else {
        setSelection(replacementEnd);
      }
    }, options.notify);
  }

  function selectRange(start, end, options = {}) {
    setSelection(start, end);
    if (options.focus) aceEditor.focus();
    if (options.reveal) {
      const position = offsetToPosition(start);
      aceEditor.scrollToLine(position.row, true, true);
    }
  }

  function clearDiagnostic() {
    session.clearAnnotations();
    if (errorMarker !== undefined) session.removeMarker(errorMarker);
    errorMarker = undefined;
    textInput.setAttribute('aria-invalid', 'false');
  }

  function setDiagnostic(problem) {
    clearDiagnostic();
    if (!problem) return;
    const requestedLine = Number(problem.line);
    if (!Number.isFinite(requestedLine) || requestedLine < 1) return;
    const lines = getSource().split('\n');
    const row = Math.min(lines.length - 1, Math.trunc(requestedLine) - 1);
    const requestedColumn = Number(problem.column);
    const column = Math.max(0, Math.min(
      lines[row].length,
      Number.isFinite(requestedColumn)
        ? Math.trunc(requestedColumn) - 1
        : 0
    ));
    const endColumn = Math.min(lines[row].length, column + 1);
    const markerEnd = endColumn > column ? endColumn : column + 1;
    const message = problem.message || 'syntax error';
    session.setAnnotations([{row, column, text: message, type: 'error'}]);
    errorMarker = session.addMarker(
      new AceRange(row, column, row, markerEnd),
      'ace-error-marker',
      'text',
      false
    );
    aceEditor.selection.moveCursorTo(row, column);
    aceEditor.clearSelection();
    aceEditor.scrollToLine(row, true, true);
    textInput.setAttribute('aria-invalid', 'true');
  }

  session.on('change', () => {
    if (!suppressChanges) notifyChange();
  });

  return {
    getSource,
    setSource,
    replaceRange,
    getSelection,
    setSelection,
    selectRange,
    offsetToPosition,
    positionToOffset,
    focus: () => aceEditor.focus(),
    onChange(listener) {
      changeListeners.add(listener);
      return () => changeListeners.delete(listener);
    },
    isFocused(target) {
      const active = document.activeElement;
      return target === host || host.contains(target)
        || active === host || host.contains(active)
        || Boolean(aceEditor.isFocused?.());
    },
    setDiagnostic,
    setTheme(effective) {
      aceEditor.setTheme(
        effective === 'dark' ? assets.darkTheme : assets.lightTheme
      );
    },
    refresh: () => aceEditor.resize(true)
  };
  '''
--
