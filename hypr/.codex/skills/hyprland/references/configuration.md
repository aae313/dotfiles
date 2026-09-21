# Hyprland Lua Configuration Reference

## Config Loading and Modules

Hyprland 0.55+ uses Lua config. On this NixOS setup, treat `~/.config/hypr/hyprland.lua` as the default source file and `~/.config/hypr` as the config root. Only use `--config` / `-c` or `HYPRLAND_CONFIG` when the user's environment or running process shows an explicit override.

Keep Hyprland behavior in Lua files under `~/.config/hypr`; use NixOS config only for enabling Hyprland system integration and making external commands/scripts available.

Split growing configs with Lua `require()`:

```lua
require("modules/monitors")
require("modules.binds")
```

Hyprland customizes `require()` so each required file gets a separate protected scope: many runtime errors abort only the required file. A missing module still errors in the caller, so use `pcall(require, "optional")` for optional modules. The original Lua `require` is available as `__require` for third-party modules that need standard behavior.

Recommended layout:

```text
~/.config/hypr/
  hyprland.lua
  modules/
    env.lua
    monitors.lua
    input.lua
    workspaces.lua
    rules.lua
    binds.lua
    visuals.lua
    startup.lua
    helpers.lua
```

Load fundamentals first: env, helpers, monitors/input, rules/workspaces, binds, startup. Keep shared values in Lua locals or a helper module, not copied string fragments. When adding helper scripts, place them in the user's existing dotfile/script layout and ensure their interpreter and external commands are provided by NixOS.

## `hl.config()`

Use `hl.config()` for option categories such as `general`, `input`, `decoration`, `animations`, `dwindle`, `master`, `scrolling`, `misc`, and nested categories. Multiple calls are valid; each updates only the passed fields.

```lua
hl.config({
  general = {
    layout = "dwindle",
    gaps_in = 4,
    gaps_out = { top = 8, right = 8, bottom = 8, left = 8 },
    border_size = 2,
  },
  decoration = {
    rounding = 6,
    blur = { enabled = true, size = 6, passes = 2 },
    shadow = { enabled = true, range = 8 },
  },
})
```

Use native Lua types: booleans as `true` / `false`, numbers as numbers, vectors as tables such as `{ 20, 20 }`, colors as supported strings such as `"#fafafa"` or `"rgba(b3ff1aee)"`, and gradients as color strings or `{ colors = { ... }, angle = 45 }`.

## Monitors

Use `hl.monitor()` entries, not legacy monitor lines. Discover names, descriptions, modes, scale, and inactive outputs with `hyprctl monitors all` or `hyprctl -j monitors all`.

```lua
hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "preferred", position = "2560x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
```

Decision rules:

- Use explicit output names for stable desktop monitors.
- Use `desc:...` only when connector names change but monitor identity is stable.
- Add one fallback rule with `output = ""` for unknown hotplugged displays.
- Calculate positions in logical pixels after scale and transform.
- Disable an output with `disabled = true`; use the `dpms` dispatcher for temporary screen-off behavior.
- Use `reserved_area` only for Hyprland-level reserved space that cannot be provided by layer-shell clients.

## Input and Devices

Use global input options in `hl.config({ input = ... })` and per-device overrides with `hl.device()`.

```lua
hl.config({
  input = {
    kb_layout = "us",
    repeat_rate = 35,
    repeat_delay = 250,
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
    },
  },
})

hl.device({
  name = "example-keyboard",
  kb_layout = "us,de",
  kb_options = "grp:alt_shift_toggle",
})
```

Find device names with `hyprctl devices`. Do not put window-management options such as `follow_mouse` into per-device config. For multi-layout binds, consider `resolve_binds_by_sym` when symbol-based activation is needed.

## Binds and Submaps

Use `hl.bind(keys, dispatcher_or_function, flags?)`. Dispatchers return action tables for `hl.bind()` or `hl.dispatch()`; they do not run by themselves.

```lua
local mod = "SUPER"

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("foot"), { description = "Open terminal" })
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
```

Use Lua functions for conditional or multi-action binds:

```lua
hl.bind(mod .. " + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)
```

Define submaps with an escape route:

```lua
hl.bind(mod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)
```

Bind flags are a table, for example `{ locked = true }`, `{ release = true }`, `{ repeating = true }`, `{ mouse = true }`, `{ submap_universal = true }`, or `{ device = { inclusive = true, list = { "keyboard-name" } } }`.

## Workspaces

Focus and move with structured dispatchers:

```lua
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i), follow = true }))
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
```

Use `hl.workspace_rule()` for workspace policy:

```lua
hl.workspace_rule({ workspace = "name:web", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", layout = "scrolling", layout_opts = { direction = "right" } })
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_in = 0, gaps_out = 0 })
```

Workspace selectors are still string selectors by design. Numeric workspace IDs must be positive.

## Window and Layer Rules

Use `hl.window_rule({ match = { ... }, effect = value })`. All match props must match. Rules are order-dependent; named rules are evaluated before anonymous rules. Later matches can override earlier effects.

```lua
hl.window_rule({
  name = "pinentry-focus",
  match = { class = "(pinentry-)(.*)" },
  stay_focused = true,
})

hl.window_rule({ match = { class = "foot" }, opacity = "0.95 override 0.85 override" })
hl.window_rule({ match = { float = true }, border_color = "rgb(88c0d0)" })
```

Static effects apply at open time and cannot react to later title/class changes. Dynamic effects are re-evaluated when matching properties change and can be controlled with `hl.dsp.window.set_prop`.

Use named rule handles for dynamic enable/disable:

```lua
local dimTerminals = hl.window_rule({
  name = "dim-terminals",
  match = { class = "foot" },
  opacity = "0.7 override",
})

hl.bind("SUPER + SHIFT + D", function()
  dimTerminals:set_enabled(not dimTerminals:is_enabled())
end)
```

Use `hl.layer_rule()` for layer-shell surfaces. Keep layer examples incidental; this skill is not about configuring bars, launchers, or notification daemons.

## Animations, Decoration, and Layouts

Declare curves and animations explicitly:

```lua
hl.curve("ease-out", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 5, curve = "ease-out", style = "popin 80%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, curve = "ease-out", style = "slidefade 20%" })
```

Avoid `loop` styles for `borderangle` or `shadowangle` unless the user accepts the constant rendering cost.

Choose layouts with `general.layout` and configure layout-specific sections:

```lua
hl.config({
  general = { layout = "dwindle" },
  dwindle = { preserve_split = true, smart_split = true },
  master = { mfact = 0.6, orientation = "left" },
  scrolling = { column_width = 0.5, follow_focus = true },
})
```

Use `hl.dsp.layout("...")` for layout messages. Layout message strings are normal in Lua config because Hyprland exposes them that way. For scripted behavior around existing layouts or custom Lua layouts, read `scripting-and-ipc.md` before editing.

Custom layouts can be registered with `hl.layout.register(name, { recalculate, layout_msg? })` and selected as `lua:name`. Prefer `target:place(...)` over manual `set_box` unless full control is necessary.

## Gestures

Use `hl.gesture()` for touchpad gestures:

```lua
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "down", mods = "SUPER", action = "special", workspace_name = "scratchpad" })
hl.gesture({
  fingers = 3,
  direction = "up",
  action = function()
    hl.exec_cmd("foot")
  end,
})
```

Gesture actions can be strings or Lua functions. To unset a gesture, repeat the same identifying fields and set `action = "unset"`.

## Startup and Environment

Use events for startup and shutdown:

```lua
hl.on("hyprland.start", function()
  hl.exec_cmd("foot --server")
end)

hl.on("hyprland.shutdown", function()
  print("Hyprland is exiting")
end)
```

Use `hl.env(key, value)` only for environment that must be set before display server initialization or before Hyprland-spawned clients inherit it. Use `os.getenv()` when composing from existing environment values. On NixOS, prefer system/session environment configuration for variables that must exist outside Hyprland-spawned processes.

Do not turn this into generic Linux desktop setup. If a long-running daemon is better managed outside Hyprland, say so and keep the Hyprland config to launching or interacting with it; NixOS should provide the program and service definition when one is needed.
