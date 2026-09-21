---
name: hyprland
description: Configure Hyprland 0.55+ on NixOS using the current Lua-based `~/.config/hypr/hyprland.lua` syntax and write Hyprland automation with Lua APIs, `hyprctl`, and IPC sockets. Use when Codex works on Hyprland monitors, input, binds, workspaces, window/layer rules, animations, decoration, layouts, gestures, startup behavior, modular Lua config organization, custom keybindings, scripted window/workspace behavior, behavior layered on existing layouts, custom Lua layouts, `hl.*` APIs, `hl.on` events, socket2 event listeners, dispatch scripts, NixOS-hosted helper scripts, or migration away from legacy `.conf`/hyprlang syntax.
---

# Hyprland

Use this skill to configure Hyprland with Lua on NixOS and to build custom desktop behavior around Hyprland's integrated Lua APIs and IPC. Scripting is central: prefer Lua functions, events, timers, dispatchers, and layout APIs for custom keybindings and behavior before reaching for external programs.

## Workflow

1. Inspect the local config before changing it. Default to `~/.config/hypr/hyprland.lua` and modules under `~/.config/hypr`; only use `$HYPRLAND_CONFIG` or launch flags such as `Hyprland --config path` if the user's environment or running process proves they override the default.
2. Read `references/scripting-and-ipc.md` first for custom behavior: function binds, stateful keybindings, behavior layered on existing layouts, custom Lua layouts, `hl.on` callbacks, timers, dynamic rules, socket clients, event listeners, or scripts that query and dispatch Hyprland state.
3. Read `references/configuration.md` before editing monitors, input/devices, declarative binds, workspaces, window/layer rules, animations, decoration, layout options, gestures, startup behavior, or Lua module organization.
4. Read `references/troubleshooting.md` before debugging config reload failures, Lua errors, stuck submaps, bad key names, monitor layout problems, rule ordering, IPC freezes, or event parsing bugs.
5. Validate with the narrowest available check: `hyprctl configerrors`, `hyprctl reload`, `hyprctl repl`, `hyprctl dispatch`, `hyprctl -j ...` queries, or a captured socket2 event stream. If Hyprland is not running, validate by static review against the reference files and clearly state that runtime validation was not possible.

## Core Rules

- Prefer current Lua APIs: `hl.config`, `hl.monitor`, `hl.device`, `hl.bind`, `hl.define_submap`, `hl.workspace_rule`, `hl.window_rule`, `hl.layer_rule`, `hl.animation`, `hl.curve`, `hl.gesture`, `hl.on`, `hl.timer`, `hl.dispatch`, and `hl.dsp.*`.
- Treat custom behavior as a first-class goal. Use Lua functions in binds/gestures, `hl.on` event handlers, timers, rule handles, `hl.dsp.layout()` messages, and `hl.layout.register()` before adding external glue.
- Assume NixOS with user-managed Lua config under `~/.config/hypr`. Do not propose non-NixOS package-manager commands or generic distro setup.
- Do not write legacy hyprlang entries such as `bind =`, `monitor =`, `windowrule =`, `exec-once =`, or `source =`. Use Lua tables, functions, and `require()` modules.
- Prefer structured dispatchers and match tables over stringly-typed legacy patterns when the Lua API provides structure. Some fields are still strings by design, such as workspace selectors, layout messages, regexes, and command strings.
- Put static desktop policy in `hyprland.lua` modules. Put long-running watchers, heavy parsing, retries, external service integration, and multi-process orchestration in separate scripts launched from config or a NixOS-managed user service when the user already uses one.
- Use `hl.on("hyprland.start", function() ... end)` for Hyprland startup commands; `hl.exec_cmd()` is already asynchronous.
- Keep external tools incidental. Mention tools only when a Hyprland config or script directly invokes them or needs their output; on NixOS, make their availability explicit through the user's NixOS package setup rather than ad-hoc install commands.
- Do not add NVIDIA-specific guidance. This skill assumes an AMD-only machine unless the user's existing config proves otherwise.

## Useful Commands

```sh
hyprctl configerrors
hyprctl reload
hyprctl repl
hyprctl repl 'hl.get_active_window()'
hyprctl dispatch 'hl.dsp.focus({ workspace = "3" })'
hyprctl -j monitors all
hyprctl -j clients
hyprctl -j devices
hyprctl -j binds
hyprctl -j workspacerules
```
