---
name: zellij
description: Automate and control Zellij through reproducible CLI commands and scripts. Use when Codex needs to compose Zellij with Helix or external developer tools; manage sessions, tabs, panes, layouts, focus, visibility, or input; launch commands with run or files with edit; inspect state as JSON; capture or subscribe to pane output; communicate with plugins through pipes; or decide whether a workflow requires a Zellij WASM plugin.
---

# Zellij Automation

Build CLI-first workflows around Zellij. Prefer explicit resource identifiers, structured output, and direct process execution over simulated interactive navigation.

## Work from observed capabilities

1. Run `zellij --version` and the relevant `zellij <command> --help` before relying on version-sensitive flags.
2. Inspect current state with `zellij action list-panes --json`, `list-tabs --json`, or `current-tab-info --json`.
3. Target another session with the global `zellij --session <name> ...` option.
4. Preserve the user's existing session, panes, and focus unless the request explicitly requires changing them.

Read [references/cli-control.md](references/cli-control.md) for command selection, resource targeting, pane management, and state interfaces.

## Choose the smallest control surface

- Use `zellij run -- <program> <args...>` to launch a command pane.
- Use `zellij edit <file> --line-number <line>` to open a file through `$EDITOR` or `$VISUAL`.
- Use `zellij action` to query or mutate an existing session.
- Use `zellij subscribe --format json` for a live NDJSON stream of rendered pane output.
- Use `zellij action dump-screen` for a point-in-time viewport or scrollback snapshot.
- Use `zellij pipe` to exchange messages with a plugin.
- Build a plugin only when the workflow requires persistent event handling, pane-content observation unavailable to the CLI, input interception, custom rendering, or another plugin-only API.

## Make automation deterministic

- Pass commands directly after `--` when possible. Avoid typing commands into an interactive shell.
- Capture IDs returned by `run`, `new-pane`, `new-tab`, `edit`, and plugin launch actions.
- Use `terminal_N` and `plugin_N` forms when pane type matters. A bare integer means `terminal_N`.
- Prefer stable tab IDs over tab positions and names for mutations.
- Pass `--pane-id` or `--tab-id` rather than changing focus as an intermediate step.
- Use `paste` for arbitrary or multiline terminal text and `send-keys "Enter"` only when interacting with an existing shell is intentional.
- Quote session names, IDs, paths, payloads, and captured command output.
- Serialize dependent actions. Do not concurrently write to the same pane.
- Treat stdout, exit status, and JSON/NDJSON as interfaces. Do not parse display tables when JSON exists.

Read [references/automation-patterns.md](references/automation-patterns.md) for Bash control loops, synchronization, failure handling, and compositions with `rg`, `fd`, `fzf`, `ast-grep`, `difft`, `jq`, and Helix.

## Distinguish process completion from pane lifecycle

- `--close-on-exit` closes a pane when its command exits.
- `--blocking` waits for both command completion and pane closure.
- `--block-until-exit` waits for command exit regardless of status.
- `--block-until-exit-success` keeps failures available for retry and unblocks on success.
- `--block-until-exit-failure` unblocks on a non-zero exit.
- A command pane can remain held after its process exits. Inspect `exited`, `exit_status`, and `is_held` from `list-panes --json`.
- A `subscribe` client exits when every subscribed pane closes or the session ends.

## Keep the Helix boundary narrow

Own the Zellij side of the workflow: session selection, pane placement, command execution, file handoff, output observation, and cleanup. Defer Helix keymaps, commands, selections, and editor configuration to Helix-specific guidance. When opening a file, prefer `zellij edit` so the configured editor contract remains intact.

## Use pipes and plugins deliberately

Read [references/pipes-and-plugins.md](references/pipes-and-plugins.md) before designing `zellij pipe`, plugin launch, backpressure, or plugin API workflows. Account for plugin identity as URL plus configuration, broadcasts versus directed messages, first-message launch behavior, permissions, and asynchronous event delivery.

## Verify solutions

- Check every proposed flag against local `--help`.
- Validate shell syntax with `bash -n` when writing a script.
- Exercise read-only queries before mutations.
- For a new session workflow, use a unique temporary session name and clean it up only if the workflow created it.
- Confirm selected IDs still exist before later mutations in long-running scripts.
- State required tools and environment variables explicitly.
