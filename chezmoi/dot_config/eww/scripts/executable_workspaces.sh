#!/bin/sh

render() {
  focused_output="$(niri msg --json focused-output | jq -r '.name // empty')"

  niri msg --json workspaces | jq -r --arg output "$focused_output" '
    map(select(.output == $output and .idx > 0 and .idx <= 5))
    | sort_by(.idx)
    | map(if .is_focused then "[\(.idx)]" else " \(.idx) " end)
    | join(" ")
  '
}

render
niri msg --json event-stream | while IFS= read -r line; do
  case "$line" in
  *'"WorkspacesChanged"'*)
    render
    ;;
  esac
done
