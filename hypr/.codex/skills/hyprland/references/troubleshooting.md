# Hyprland Lua Troubleshooting

## Reload and Lua Errors

Assume NixOS with Lua config in `~/.config/hypr/hyprland.lua`. Do not give non-NixOS package-manager advice.

Use:

```sh
hyprctl configerrors
hyprctl reload
hyprctl repl
hyprctl rollinglog
```

Error behavior to account for:

- Fundamental Lua syntax errors can make Hyprland refuse to reload the config.
- Runtime Lua errors abort the current Lua file.
- Runtime Hyprland type errors usually continue execution but report an error.
- Runtime errors in async execution, such as keybind functions, surface as notifications.
- A major error before binds in the same file can prevent those binds from loading.

Keep core emergency binds early or in a small required module. Use Hyprland's emergency binds if startup fails.

## `require()` Problems

Symptoms: a whole module did not load, later binds/rules are missing, or the main config stopped after an optional module.

Checks:

- Confirm paths are relative to `hyprland.lua`.
- Use either `require("dir/file")` or `require("dir.file")`.
- Remember missing modules throw in the caller even though runtime errors inside required files are scoped.
- Use `pcall(require, "optional-module")` for optional modules.
- Avoid circular module initialization; put shared values in a helper module and require it from consumers.

## Legacy Syntax Mistakes

Do not write old hyprlang lines in Lua files:

```lua
-- Wrong in hyprland.lua
-- monitor = DP-1,2560x1440@165,0x0,1
-- bind = SUPER,Q,killactive
-- exec-once = some-command
```

Use current Lua forms:

```lua
hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.on("hyprland.start", function() hl.exec_cmd("command") end)
```

## Type and Shape Errors

Use the documented Lua shapes exactly:

- `hl.config()` takes nested tables by category.
- `hl.monitor()` takes a table with `output`, `mode`, `position`, `scale`, and optional fields.
- `hl.bind()` takes a key string, a dispatcher table or function, and optional flags table.
- `hl.window_rule()` and `hl.layer_rule()` require a `match` table.
- `hl.workspace_rule()` takes one table with `workspace = ...` plus rule fields.
- `hl.animation()` requires `leaf`, `enabled`, and curve/style fields when enabled.

Common fixes:

- Replace `"true"` / `"false"` strings with booleans.
- Replace numeric strings with numbers unless the field is documented as a string.
- Use `{ top = ..., right = ..., bottom = ..., left = ... }` for css gaps when sides differ.
- Use supported color strings such as `"#aabbcc"`, `"rgb(aabbcc)"`, or `"rgba(aabbccdd)"`.

## Binds and Submaps

If a bind does not trigger:

- Check exact key names with `wev` or `hyprctl binds`.
- Use `code:N` for keycode binds when layout symbols are unreliable.
- For no-modifier binds, use just the key, such as `"Print"`.
- For mouse buttons, use `mouse:272`, `mouse:273`, etc.
- If multiple keyboard layouts are configured, check `resolve_binds_by_sym`.
- Ensure bind flags are in the third argument table.

If stuck in a submap:

```sh
hyprctl dispatch 'hl.dsp.submap("reset")'
```

Always include an `escape` or catch-all reset bind in submaps.

## Monitor Layout Problems

Use `hyprctl monitors all` or `hyprctl -j monitors all`.

Common fixes:

- Positions are logical pixels after scale and transform.
- Negative Y places a monitor above; positive Y places it below.
- Monitors cannot overlap.
- Fractional scale must divide the physical mode into valid logical pixels.
- For unknown hotplugged displays, add a fallback `hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })`.
- For description matching, use `desc:` without the connector suffix in parentheses.

## Window Rule Problems

Rules are evaluated top to bottom, with named rules before anonymous rules. Put broad defaults first and specific overrides later.

Static effects apply once at open time. They cannot respond to title/class changes after a window is created. Use dynamic effects or event-driven logic when matching properties change later.

Debug rules with:

```sh
hyprctl -j clients
hyprctl -j workspacerules
hyprctl getprop activewindow opacity
```

Regexes use RE2. Unsupported backtracking-heavy patterns will not work. Use `negative:` to negate a regex when needed.

Opacity multiplies by default. Add `override` to force exact opacity values and avoid accidental products.

## Startup Problems

Use `hl.on("hyprland.start", function() ... end)` instead of legacy `exec-once`. `hl.exec_cmd()` spawns asynchronously; do not add shell backgrounding unless the command itself requires shell behavior.

Keep startup minimal in Hyprland config. Long-running services are often better managed outside the config, with Hyprland only dispatching or launching them when needed.

## IPC Freezes and Event Bugs

If Hyprland freezes after IPC work, suspect `.socket.sock` clients that did not close. That socket is synchronous. Open, send, read, and close immediately.

For socket2:

- Split event lines on the first `>>`.
- Do not assume every event has comma-separated fields.
- Prefer v2 events with IDs when available.
- Treat fullscreen events as non-paired; apps may emit repeated fullscreen requests.
- Handle empty event data.
- Reconnect after Hyprland restarts.

Avoid feedback loops: if a socket2 listener dispatches an action that triggers the same event, debounce it or record the expected self-trigger.

## Reentrant or Long-Running Lua

Hyprland has protections against infinite scripts, but do not rely on them. Avoid unbounded loops in config, `hl.on` callbacks, binds, and timers.

For repeated work, use `hl.timer()` with explicit enable/disable behavior or extract to an external script. For event handlers, keep callbacks short and defer heavy work outside the compositor when possible.
