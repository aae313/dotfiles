# Automation Patterns

## Contents

- [Control loop](#control-loop)
- [Synchronization](#synchronization)
- [Streaming output](#streaming-output)
- [Concurrency](#concurrency)
- [Tool compositions](#tool-compositions)
- [Helix handoff](#helix-handoff)
- [Failure handling](#failure-handling)

All examples use POSIX/Bash syntax.

## Control loop

A reliable external controller creates or selects a session, creates resources, captures their IDs, observes structured state, reacts, and cleans up only resources it owns.

```bash
#!/usr/bin/env bash
set -euo pipefail

session="workflow-$$"
zellij attach --create-background "$session"

pane_id=$(
  zellij --session "$session" action new-pane \
    --name checks --close-on-exit \
    -- bash -lc 'rg --line-number TODO .'
)

zellij --session "$session" subscribe \
  --pane-id "$pane_id" --format json |
  jq --unbuffered '
    if .event == "pane_update" then .viewport[]
    elif .event == "pane_closed" then "closed: \(.pane_id)"
    else empty
    end
  '
```

Use a unique session name when a workflow owns the session. Before adopting an existing session, query and identify resources rather than assuming `terminal_1`.

## Synchronization

Choose synchronization by the actual requirement:

| Requirement | Mechanism |
|---|---|
| Wait until a process exits | `--block-until-exit` |
| Continue only after success | `--block-until-exit-success` |
| Continue after expected failure | `--block-until-exit-failure` |
| Let a human inspect and close the pane | `--blocking` |
| Detect output as it changes | `subscribe --format json` |
| Poll current/final output | `dump-screen` |
| Inspect process completion | `list-panes --json` |

Directly launching the command makes `exited` and `exit_status` meaningful:

```bash
while :; do
  pane=$(
    zellij action list-panes --json |
      jq --arg id "$pane_id" '
        .[] |
        select((if .is_plugin then "plugin_" else "terminal_" end) + (.id | tostring) == $id)
      '
  )
  test -n "$pane" || break
  test "$(jq -r '.exited' <<<"$pane")" = true && break
  sleep 1
done
```

Do not infer command completion merely because output stopped changing.

## Streaming output

`subscribe` immediately emits the current viewport, then emits changed viewports. JSON mode is NDJSON:

```json
{"event":"pane_update","pane_id":"terminal_1","viewport":["line"],"scrollback":null,"is_initial":true}
{"event":"pane_closed","pane_id":"terminal_1"}
```

Use `jq --unbuffered` for event loops:

```bash
zellij subscribe --pane-id "$pane_id" --format json |
  jq --unbuffered -r '
    select(.event == "pane_update") |
    .viewport[] |
    select(test("error|warning"; "i"))
  '
```

Pass `--scrollback N` or bare `--scrollback` for initial history. Subsequent events contain changed viewport content, not an append-only process-output stream. If exact stdout/stderr records matter, make the launched process write a log or pipe its output to a dedicated collector.

## Concurrency

Each CLI invocation connects, sends one request, and disconnects. Sequence dependent actions:

```bash
pane_id=$(zellij action new-pane) &&
  zellij action paste --pane-id "$pane_id" "$command" &&
  zellij action send-keys --pane-id "$pane_id" "Enter"
```

Independent operations on different panes can run concurrently. Concurrent writes to one pane can interleave and must be serialized by a single controller or lock.

Queries during mutations are safe snapshots, but state can become stale before a later mutation. Revalidate long-lived IDs.

## Tool compositions

Run searches directly in command panes:

```bash
zellij run --name ripgrep --cwd "$project" -- rg --line-number --hidden pattern .
zellij run --name structural --cwd "$project" -- ast-grep run --pattern '$A.unwrap()' .
zellij run --name diff --cwd "$project" -- difft before.rs after.rs
```

Use a shell only for pipelines and shell syntax:

```bash
zellij run --name files --floating --cwd "$project" -- \
  bash -lc 'fd --type f --hidden --exclude .git | fzf --preview "rg --color=always --context 3 --fixed-strings -- {q} {}"'
```

Passing arbitrary user text into `bash -lc` requires careful quoting. Prefer positional parameters:

```bash
zellij run --name search --cwd "$project" -- \
  bash -lc 'rg --line-number -- "$1" .' bash "$needle"
```

Check each tool independently before composing it:

```bash
command -v zellij rg fd fzf ast-grep difft jq hx
```

## Helix handoff

Keep selection and cursor acquisition on the Helix side. Give the Zellij layer explicit values such as project directory, file path, line number, selection text, or target pane ID.

Open a selected file through the configured editor:

```bash
zellij edit --cwd "$project" "$file" --line-number "$line"
```

If the workflow must target an already-running Helix pane, identify it from `list-panes --json` using known title, command, cwd, or an ID recorded when it was created. Do not select the first pane whose command happens to contain `hx`.

Use `zellij run` for transient search, picker, diagnostics, test, and diff panes. Decide placement explicitly:

- Floating for short-lived pickers and overlays.
- In-place for temporary full-pane tools where suppression is desired.
- Tiled or stacked for persistent companions.
- Background session or direct command pane for unattended work.

## Failure handling

- Use `set -euo pipefail` only when immediate failure is appropriate; interpret commands with state-reporting non-zero statuses explicitly.
- Capture an ID only if creation succeeded and stdout contains the expected form.
- Check that a session exists before targeting it.
- Distinguish missing panes from closed panes and exited-but-held panes.
- Apply timeouts around indefinitely blocking subscriptions or polling loops when unattended execution requires a bound.
- Preserve stderr for diagnostics rather than discarding it.
- Do not kill sessions, close user panes, or replace panes unless ownership or user intent is clear.
