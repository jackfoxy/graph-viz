# Keyboard shortcuts

Graph Viz's own shortcuts. The editor's are in
**[Ace editor keys](ace-keys.md)**.

## Graph Viz

<!-- generated: app-chords -->

| Key | Action | Where |
|:----|:-------|:------|
| F1 | Help (displaces Ace’s Open command palette) | Everywhere |
| F2 | Settings (displaces Ace’s Toggle fold widget) | Everywhere |
| Ctrl-Enter | Render now (displaces Ace’s Enter full screen) | Everywhere |
| Ctrl-S | Save the DOT source | Everywhere |
| Ctrl-Shift-S | Save the SVG | Everywhere |
| Alt-O | Open a saved DOT file | Outside the editor |
| Alt-C | Copy the DOT source | Outside the editor |
| Ctrl-Alt-V | SVG source or preview | Outside the editor |
| Ctrl-0 | Fit the graph | With a live preview |
| Ctrl-1 | Reset the view | With a live preview |
| Ctrl-Shift-0 | Reset the view | With a live preview |

<!-- /generated -->

F1, F2 and Ctrl-Enter override Ace bindings. The command palette's commands
remain reachable through **Ctrl-,**, Ace's own settings menu; folding keeps
`Alt-F2`, `Alt-L`, `Alt-Shift-L`, `Alt-0` and `Alt-Shift-0`. Ctrl-Enter is
Ace's fullscreen upstream, but the pinned standalone bundle ships no such
command, so nothing is displaced in practice.

Alt-O and Alt-C, rather than Ctrl-O and Ctrl-Shift-C: **Ctrl-O** is free in
Ace's own keymap but is a Vim binding in both insert and normal mode, and the
editor can be switched to Vim in Settings; **Ctrl-Shift-C** is Chromium's
element inspector. These two, the display toggle and the row keys apply
outside the editor only, so Ctrl-C and its neighbours keep their ordinary
meaning while editing.

**Save As has no chord.** Ctrl-Shift-S is Save SVG here and Ctrl-Alt-S is
Ace's Sort lines, so Save As stays on its button — the one place in the
cross-app table where a sensible chord is already taken.

Ctrl-Shift-0 is an alias for Reset. Ctrl-1 is delivered to the page and
cancelable in Chromium, but Ctrl-1 through Ctrl-8 are the browser's tab
switches, so the alias is there for any engine that keeps them.

The key badge on each control, and the binding in its tooltip, come from this
same table at load: no binding is written into the markup.

## Ace editor

The DOT source pane uses the vendored Ace editor. Its full default keymap
is in **[Ace editor keys](ace-keys.md)**, generated from the same manifest
the cross-app conflict gate reads. **Settings → Keybindings** selects the
default or the Vim keymap.

## Dialogs

Help and Settings navigate the same way in every app on this shell; see
**[Dialog keyboard contract](modal-keys.md)**.

## Policy

Why a chord is or is not available, and what it may displace:
**[Key policy](key-policy.md)**.
