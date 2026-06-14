#!/bin/sh

render() {
  workspaces="$(niri msg -j workspaces 2>/dev/null)" || return

  printf '%s\n' "$workspaces" | jq -r '
    map(select(.idx > 0 and .idx <= 5))
    | sort_by(.idx)
    | map((if (.name // "") == "main" then 1 else .idx end) as $label | if .is_focused then "[\($label)]" else " \($label) " end)
    | join(" ")
  '
}

render
niri msg workspaces >/dev/null 2>&1 || exit 0
niri msg -j event-stream 2>/dev/null | while IFS= read -r line; do
  render
done
