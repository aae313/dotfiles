# CLI Control and Pane Management

## Contents

- [Session targeting](#session-targeting)
- [Command selection](#command-selection)
- [Resource identifiers](#resource-identifiers)
- [State queries](#state-queries)
- [Pane and tab operations](#pane-and-tab-operations)
- [Input and output](#input-and-output)
- [Layouts and visibility](#layouts-and-visibility)
- [Exit-status interfaces](#exit-status-interfaces)

## Session targeting

Create a detached session:

```bash
zellij attach --create-background "$session"
zellij attach --create-background "$session" options --default-layout /absolute/layout.kdl
```

Target it from any shell:

```bash
zellij --session "$session" action list-panes --json
zellij --session "$session" action new-pane --name build -- cargo build
zellij --session "$session" subscribe --pane-id "$pane_id" --format json
```

Use `zellij list-sessions`, `attach`, `watch`, `kill-sessions`, and `kill-all-sessions` for session lifecycle. Do not use `kill-all-sessions` in automation unless the user explicitly requests global teardown.

## Command selection

| Need | Interface |
|---|---|
| Run a program in a new pane | `zellij run [pane options] -- program args...` |
| Open a file in the configured editor | `zellij edit [pane options] file` |
| Create or mutate panes and tabs | `zellij action ...` |
| Read current rendered output once | `zellij action dump-screen` |
| Stream rendered output | `zellij subscribe` |
| Launch a plugin directly | `zellij plugin -- URL` |
| Send messages to plugins | `zellij pipe` |

`zellij run` is the short form of `zellij action new-pane` for terminal commands. Both print the created pane ID. Common placement flags include `--floating`, `--in-place`, `--direction`, `--stacked`, `--cwd`, `--name`, `--tab-id`, coordinates, dimensions, `--pinned`, and `--borderless`.

`zellij edit` accepts the same main placement controls plus `--line-number`. It prints the created editor pane ID.

## Resource identifiers

Terminal and plugin pane numeric IDs overlap. Use:

- `terminal_3` for terminal pane 3.
- `plugin_3` for plugin pane 3.
- `3` only when intentionally referring to `terminal_3`.

Inside a terminal pane, `$ZELLIJ_PANE_ID` identifies that pane. Discover all IDs instead of assuming allocation:

```bash
panes_json=$(zellij action list-panes --json)
tabs_json=$(zellij action list-tabs --json)
```

Creation commands returning IDs include `new-pane`, `run`, `edit`, `launch-plugin`, `launch-or-focus-plugin`, and `new-tab`. `go-to-tab-name --create` returns an ID only when it creates the tab.

Tab positions can change. Use the stable `tab_id` from JSON with actions supporting `--tab-id`.

## State queries

Prefer these machine interfaces:

```bash
zellij action list-panes --json
zellij action list-tabs --json
zellij action current-tab-info --json
```

`list-panes --json` exposes pane type, focus, floating/suppressed/fullscreen state, title, command, cwd, geometry, tab, exit state, and exit status. `list-tabs --json` exposes stable ID, position, name, active state, dimensions, pane counts, floating visibility, sync state, and layout state.

Other queries:

```bash
zellij action list-clients
zellij action query-tab-names
zellij action dump-layout
zellij action are-floating-panes-visible --tab-id "$tab_id"
```

## Pane and tab operations

Create resources and retain their IDs:

```bash
pane_id=$(zellij action new-pane --name tests -- cargo test)
tab_id=$(zellij action new-tab --name diagnostics)
editor_id=$(zellij edit src/main.rs --line-number 42)
```

Common explicit-ID actions:

```bash
zellij action focus-pane-id "$pane_id"
zellij action close-pane --pane-id "$pane_id"
zellij action rename-pane --pane-id "$pane_id" build
zellij action resize --pane-id "$pane_id" right
zellij action move-pane --pane-id "$pane_id" left
zellij action toggle-fullscreen --pane-id "$pane_id"
zellij action close-tab --tab-id "$tab_id"
zellij action rename-tab --tab-id "$tab_id" tools
```

Control floating panes:

```bash
zellij action new-pane --floating --x 10% --y 10% --width 80% --height 80% -- tool
zellij action change-floating-pane-coordinates --pane-id "$pane_id" --x 20 --y 5 --width 60% --height 70%
zellij action show-floating-panes --tab-id "$tab_id"
zellij action hide-floating-panes --tab-id "$tab_id"
zellij action toggle-pane-pinned --pane-id "$pane_id"
zellij action toggle-pane-embed-or-floating --pane-id "$pane_id"
```

Other useful operations include `stack-panes`, `set-pane-borderless`, `set-pane-color`, `clear`, scroll actions, `edit-scrollback`, `save-session`, and `override-layout`.

## Input and output

Prefer direct argv execution:

```bash
pane_id=$(zellij action new-pane --cwd "$project" -- rg --line-number TODO .)
```

When an existing shell must receive input:

```bash
zellij action paste --pane-id "$pane_id" "$command"
zellij action send-keys --pane-id "$pane_id" "Enter"
```

`paste` uses bracketed paste mode and is preferable for text. `write-chars` sends characters one by one. `write` sends numeric bytes. `send-keys` sends named keys and modifiers.

Capture rendered content:

```bash
zellij action dump-screen --pane-id "$pane_id"
zellij action dump-screen --pane-id "$pane_id" --full
zellij action dump-screen --pane-id "$pane_id" --full --ansi
```

Plain text is the default. Use `--ansi` only when styling is semantically required.

## Layouts and visibility

Create a tab from a file or inline KDL:

```bash
zellij action new-tab --layout /absolute/layout.kdl --name tools
zellij action new-tab --layout-string 'layout { pane split_direction="vertical" { pane; pane; }; }'
```

Override runtime layout:

```bash
zellij action override-layout /absolute/layout.kdl \
  --retain-existing-terminal-panes \
  --retain-existing-plugin-panes \
  --apply-only-to-active-tab
```

In-place panes suppress the replaced pane unless `--close-replaced-pane` is supplied. Suppression preserves the replaced process; closing destroys it.

## Exit-status interfaces

`are-floating-panes-visible` prints `true` and exits 0 when visible; it prints `false` and exits 1 when hidden.

For `show-floating-panes` and `hide-floating-panes`, use the installed CLI help as the final authority. Current documentation defines:

- `0`: visibility changed.
- `1`: target tab or floating panes not found, depending on command/version.
- `2`: already in the requested state.

Do not treat a non-zero state-reporting status as an unexpected process failure without interpreting the command contract.
