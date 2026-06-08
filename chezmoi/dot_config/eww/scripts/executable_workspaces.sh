#!/bin/sh

render() {
  active="$(hyprctl -j activeworkspace | jq -r '.id // 0')"

  hyprctl -j workspaces | jq -r --argjson active "$active" '
    map(select(.id > 0 and .id <= 5))
    | sort_by(.id)
    | map(if .id == $active then "[\(.id)]" else " \(.id) " end)
    | join(" ")
  '
}

render
hyprctl -j activeworkspace >/dev/null 2>&1 || exit 0
socat -U - "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while IFS= read -r line; do
  case "$line" in
  workspace* | focusedmon*)
    render
    ;;
  esac
done
