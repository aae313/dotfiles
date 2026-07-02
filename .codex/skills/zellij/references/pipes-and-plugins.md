# Pipes and Plugin Escalation

## Contents

- [Choose CLI or plugin](#choose-cli-or-plugin)
- [Pipe model](#pipe-model)
- [CLI usage](#cli-usage)
- [Backpressure and output](#backpressure-and-output)
- [Plugin event model](#plugin-event-model)
- [Relevant plugin capabilities](#relevant-plugin-capabilities)
- [Safety and correctness](#safety-and-correctness)

## Choose CLI or plugin

Stay with the CLI when a controller can:

- Query state with `list-panes`, `list-tabs`, or `current-tab-info`.
- Create, target, move, resize, show, hide, rename, or close resources.
- Launch commands or editors and capture their IDs.
- Inject input into known panes.
- Snapshot or subscribe to rendered pane output.
- Exchange string messages with an existing plugin.

Escalate to a WASM plugin when the workflow requires persistent in-session UI, subscribed application events, input interception, clickable pane highlights, plugin-to-plugin messaging, controlled CLI-pipe backpressure, filesystem events, or plugin-only access to pane contents and host APIs.

Do not propose a plugin merely to wrap a sequence of available CLI commands.

## Pipe model

A pipe message has optional:

- Name: arbitrary string; unnamed pipes receive a UUID.
- Payload: arbitrary string.
- Arguments: string-to-string values.
- Destination: plugin URL plus plugin configuration, or a plugin ID when initiated by another plugin.

An undirected pipe broadcasts to every listening plugin. A directed pipe launches the destination plugin on the first message if it is not already running.

Plugin identity includes both URL and configuration. Two instances using the same URL with different configuration are distinct destinations. Runtime configuration changes do not change the identity established at load time.

## CLI usage

Send one message to a known plugin:

```bash
zellij pipe \
  --name open-result \
  --plugin file:/absolute/path/plugin.wasm \
  -- 'payload'
```

Broadcast:

```bash
zellij pipe --name notification -- 'build finished'
```

Stream stdin and consume plugin output:

```bash
producer |
  zellij pipe --name records --plugin my-plugin-alias |
  consumer
```

Configuration selects the destination:

```bash
zellij pipe \
  --name index \
  --plugin my-plugin-alias \
  --plugin-configuration 'role=search' \
  -- 'refresh'
```

Check the installed `zellij pipe --help` before using newer launch-placement flags. `zellij action pipe` exposes additional controls in versions that support them, including force launch, cache skipping, plugin placement, cwd, and title.

## Backpressure and output

For CLI pipes reading stdin, Zellij sends messages under backpressure: the input buffer advances after listening plugins process and render or decline to render. This is slower than a native shell pipeline and should not be used as a high-throughput byte stream.

A plugin receiving a CLI `PipeSource` gets the pipe ID. With `ReadCliPipes` permission it can:

- `block_cli_pipe_input(pipe_id)` to pause delivery.
- `unblock_cli_pipe_input(pipe_id)` to resume delivery.
- `cli_pipe_output(pipe_id, text)` to write to the CLI pipe's stdout.

Output is independent of input blocking. Multiple plugins or instances can write to the same CLI pipe stdout. Consumers must tolerate interleaving unless the protocol establishes ownership or framing.

## Plugin event model

A plugin subscribes to `EventType` values and receives typed `Event` payloads through `update`. Relevant automation events include:

- `TabUpdate` and `PaneUpdate` for application state.
- `CommandPaneOpened`, `CommandPaneExited`, and `CommandPaneReRun`.
- `EditPaneOpened` and `EditPaneExited`.
- `PaneClosed`.
- `PaneRenderReport` and `PaneRenderReportWithAnsi`.
- `RunCommandResult`.
- `ActionComplete`.
- `CwdChanged` and `CommandChanged`.
- `UserAction` and `InterceptedKeyPress`.
- `HighlightClicked`.
- `BeforeClose`.

Correlate asynchronous operations with the context dictionaries accepted by command-opening, background-command, and action APIs. Do not correlate solely by event order.

Permissions are explicit. Request only those required, typically during `load`, and handle `PermissionRequestResult::Denied` without pretending the operation succeeded.

## Relevant plugin capabilities

Use these families when CLI limitations justify a plugin:

- State: `get_focused_pane_info`, `get_pane_info`, `get_tab_info`, `get_pane_pid`, `get_pane_running_command`, `get_pane_cwd`, and `get_session_list`.
- Contents: `get_pane_scrollback` and pane render report events with `ReadPaneContents`.
- Creation: `open_file*`, `open_terminal*`, `open_command_pane*`, plugin-pane functions, and new-tab functions.
- Targeted control: focus, close, rename, resize, move, float/embed, hide/show, stack, color, borderless, write, and signal functions accepting `PaneId`.
- Background integration: `run_command`, timers, workers, and `RunCommandResult`.
- Communication: `pipe_message_to_plugin` and worker messages.
- Generic actions: `run_action` plus `ActionComplete`.
- Content affordances: `set_pane_regex_highlights` plus `HighlightClicked`.

Use `PaneId::Terminal(n)` and `PaneId::Plugin(n)` rather than collapsing pane types. Stable tab IDs are distinct from tab positions.

## Safety and correctness

- Treat plugin URLs and configuration as identity and routing data.
- Avoid broadcast pipes for private or destructive operations.
- Define message names, payload encoding, argument keys, response framing, and versioning before building a multi-process protocol.
- Bound payload sizes and validate untrusted strings before passing them to host commands.
- Avoid rendering on every high-frequency pipe message unless necessary.
- Preserve context across asynchronous events.
- Handle plugin launch failure, permission denial, target disappearance, duplicate instances, and CLI disconnection.
- Use `zellij:OWN_URL` only for intentional self-launch patterns, and change configuration so a new instance is distinguishable from the sender.
