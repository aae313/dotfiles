# Hyprland Scripting and IPC Reference

Use this reference for custom behavior, not only IPC. Hyprland's Lua config is a scripting surface for custom keybindings, event reactions, dynamic rules, behavior layered onto existing layouts, and full custom Lua layouts.

## Choose the Right Execution Place

Put logic in Lua config when it:

- Depends directly on `hl.*` state objects, dispatchers, window/workspace/monitor objects, or config handles.
- Is short, synchronous, and tied to a bind, gesture, timer, or `hl.on` event.
- Updates Hyprland config or rules with `hl.config()`, rule handles, or `hl.dispatch()`.
- Customizes behavior of an existing layout through layout messages, workspace rules, or window rules.
- Defines a custom layout with `hl.layout.register()`.

Put logic in a separate script when it:

- Runs continuously outside config reloads.
- Watches `.socket2.sock` events for a long time.
- Parses JSON, calls several external commands, manages retries, or coordinates non-Hyprland services.
- Needs isolation from config reload failures or should be testable with captured input.

Use config to launch or bind that script, not to embed a large program. On NixOS, do not suggest ad-hoc installation steps for script dependencies; note which commands must be present through the user's NixOS package configuration.

Decision rule: if the behavior can be expressed through `hl.get_*`, `hl.dispatch`, `hl.config`, rule handles, `hl.on`, `hl.timer`, or `hl.layout.register`, keep it in Lua config. Extract to a separate script only when the logic is long-running, process-heavy, or mostly about non-Hyprland systems.

## Integrated Lua APIs

Use `hl.on(event, callback)` for in-process events. Multiple handlers can be registered.

```lua
hl.on("window.active", function(window)
  if window ~= nil then
    print("active window: " .. window.title)
  end
end)

hl.on("workspace.move_to_monitor", function(workspace, monitor)
  print(workspace.name .. " moved to " .. monitor.name)
end)
```

Common event families include `hyprland.start`, `hyprland.shutdown`, `window.*`, `monitor.*`, `workspace.*`, `config.reloaded`, `config.props_refreshed`, `keybinds.submap`, and `screenshare.state`.

Use convenience getters instead of shelling out when already inside Lua config:

```lua
local window = hl.get_active_window()
local workspace = hl.get_active_workspace()
local monitor = hl.get_active_monitor()
local all_windows = hl.get_windows()
local config_value = hl.get_config("general.gaps_in")
```

Use `hl.dispatch()` with `hl.dsp.*` for actions:

```lua
hl.bind("SUPER + SHIFT + G", function()
  local gaps = hl.get_config("general.gaps_in")
  local next_gaps = gaps.top == 0 and 4 or 0

  hl.config({ general = { gaps_in = next_gaps, gaps_out = next_gaps } })
end)

hl.bind("SUPER + X", function()
  local window = hl.get_active_window()
  if window ~= nil and window.class == "foot" then
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
  else
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  end
end)
```

Use `hl.timer(callback, { timeout = ms, type = "repeat" | "oneshot" })` for delayed or repeated in-config work. Store handles when a timer must be toggled or disabled.

## Custom Keybinding Behavior

Use function binds when a key should inspect state, dispatch multiple actions, update config, toggle a rule, or branch on the active window/workspace.

```lua
hl.bind("SUPER + SPACE", function()
  local window = hl.get_active_window()
  if window == nil then
    return
  end

  if window.class == "foot" then
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
  else
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
    hl.dispatch(hl.dsp.window.center())
  end
end)
```

Use submaps for modal behavior and include a guaranteed reset path:

```lua
hl.bind("SUPER + R", hl.dsp.submap("layout-adjust"))

hl.define_submap("layout-adjust", function()
  hl.bind("H", hl.dsp.layout("splitratio -0.1"), { repeating = true })
  hl.bind("L", hl.dsp.layout("splitratio +0.1"), { repeating = true })
  hl.bind("F", hl.dsp.layout("fit active"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)
```

Prefer one Lua function over chains of shell commands. Use `hl.dsp.exec_cmd()` only when the behavior genuinely belongs to another program.

## Behavior on Existing Layouts

Customize existing layouts with three layers, from least invasive to most dynamic:

- Static config: `hl.config({ dwindle = ... })`, `hl.config({ master = ... })`, `hl.config({ scrolling = ... })`.
- Workspace policy: `hl.workspace_rule({ workspace = ..., layout = ..., layout_opts = ... })`.
- Scripted actions: function binds or `hl.on` callbacks that call `hl.dispatch(hl.dsp.layout("..."))`.

Examples:

```lua
hl.bind("SUPER + bracketleft", hl.dsp.layout("mfact -0.05"))
hl.bind("SUPER + bracketright", hl.dsp.layout("mfact +0.05"))

hl.bind("SUPER + comma", function()
  local workspace = hl.get_active_workspace()
  if workspace ~= nil and workspace.name == "wide" then
    hl.dispatch(hl.dsp.layout("colresize +conf"))
  else
    hl.dispatch(hl.dsp.layout("splitratio +0.1"))
  end
end)
```

Use layout messages because upstream exposes existing-layout controls that way. Keep the message string small and documented near the bind, and do not translate it into legacy config syntax.

For event-driven behavior, react to Hyprland events and keep the callback short:

```lua
hl.on("workspace.active", function(workspace)
  if workspace ~= nil and workspace.name == "focus" then
    hl.config({ general = { gaps_in = 0, gaps_out = 0 } })
  else
    hl.config({ general = { gaps_in = 4, gaps_out = 8 } })
  end
end)
```

Be careful with behavior that changes state in response to the same state changing. Add guards or debounce timers to avoid loops.

## Custom Lua Layouts

Use `hl.layout.register(name, { recalculate, layout_msg? })` when existing layouts plus layout messages cannot express the behavior. Select the layout as `lua:name`.

```lua
hl.layout.register("columns", {
  recalculate = function(ctx)
    local count = #ctx.targets
    if count == 0 then
      return
    end

    for index, target in ipairs(ctx.targets) do
      target:place(ctx:column(index, count))
    end
  end,
})

hl.config({ general = { layout = "lua:columns" } })
```

Custom layout rules:

- Prefer `target:place(...)`; it preserves gaps, pseudotiling, reserved space, and related Hyprland behavior.
- Use `target:set_box(...)` only when full manual positioning is necessary.
- Treat `ctx.targets` as layout targets, not always one plain window. Check `target.window` defensively.
- Keep layout state explicit and small. If a layout needs custom messages, verify the current `layout_msg` callback shape from local stubs or upstream examples before coding it.
- Keep layout code in its own module, for example `~/.config/hypr/modules/layouts/columns.lua`, and require it before selecting `lua:name`.

Do not build a custom layout when a normal layout option, workspace rule, or layout message already solves the problem.

## Prop Refresh

Some config and rule changes schedule a prop refresh after the current event or Lua function. Do not assume a value changed by a workspace rule is visible to later code in the same callback.

Use `hl.exec_scheduled_prop_refresh_immediately()` only when immediate updated state is required. Avoid repeated calls in hot paths.

## `hyprctl` for Scripts and Debugging

Use `hyprctl` when outside the Lua config or when debugging from a shell:

```sh
hyprctl repl 'hl.get_active_window().class'
hyprctl eval 'hl.notification.create({ text = "hello", timeout = 2000 })'
hyprctl dispatch 'hl.dsp.focus({ workspace = "3" })'
hyprctl -j clients
hyprctl -j monitors all
hyprctl -j workspaces
hyprctl -j devices
hyprctl -j binds
```

`hyprctl dispatch` is shorthand for evaluating `hl.dispatch(...)`. Prefer `-j` for machine-readable info queries. Use `--batch` only when multiple control calls are required; avoid tight loops that spam synchronous compositor calls.

## IPC Socket Paths

Hyprland exposes sockets under:

```text
$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock
$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
```

`.socket.sock` accepts hyprctl-like requests. Connections are synchronous. Always open the socket, send the request, read the reply, and close promptly; an unclosed connection can freeze Hyprland until its timeout.

`.socket2.sock` streams events. Each event line is:

```text
EVENT>>DATA\n
```

Example:

```text
workspace>>2
openwindow>>0xabc,name:web,foot,title
```

## Socket2 Event Consumers

Use socket2 for long-running event listeners when `hl.on` is not appropriate, such as separate daemons, status producers, or scripts that should survive config reloads.

Shell skeleton:

```sh
#!/bin/sh
set -eu

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

handle_event() {
  event=${1%%>>*}
  data=${1#*>>}

  case "$event" in
    workspacev2) : ;;
    focusedmonv2) : ;;
    activewindowv2) : ;;
    configreloaded) : ;;
  esac
}

socat -U - "UNIX-CONNECT:$socket" | while IFS= read -r line; do
  handle_event "$line"
done
```

Parsing rules:

- Split only on the first `>>`.
- Treat the data side as event-specific; window titles and classes can contain punctuation.
- Prefer `*v2` events when they provide stable IDs.
- Handle empty payloads, especially `configreloaded` and closed special workspace events.
- Reconnect when the socket closes because Hyprland restarted.

## Dispatching from External Scripts

For one-shot mutations, prefer `hyprctl dispatch`:

```sh
hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })'
hyprctl dispatch 'hl.dsp.focus({ workspace = "special:scratchpad" })'
```

For scripts that need state, query JSON first:

```sh
focused_class=$(hyprctl -j activewindow | jq -r '.class // empty')

if [ "$focused_class" = "foot" ]; then
  hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'
fi
```

Do not parse pretty `hyprctl` output in new scripts when `-j` is available. Keep external dependencies such as `jq` or `socat` explicit and incidental to the script, and call out that they must be available from NixOS configuration.

## Config and Script Integration

Bind scripts with `hl.dsp.exec_cmd()` when shell evaluation is desired, or `hl.dsp.exec_raw()` when a raw command invocation is required by the local config style.

```lua
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("hypr-monitor-profile toggle"))
```

If a script exists only to call a single Hyprland action, keep it in Lua instead. If a Lua bind grows into process management, network calls, or complex parsing, extract it to a script.

For generated scripts:

- Read environment variables at runtime, especially `HYPRLAND_INSTANCE_SIGNATURE` and `XDG_RUNTIME_DIR`.
- Fail loudly when required variables are missing.
- Avoid polling when socket2 events provide the needed signal.
- Debounce noisy events if the script dispatches actions in response.
- Prevent feedback loops when reacting to events caused by the script's own dispatches.
