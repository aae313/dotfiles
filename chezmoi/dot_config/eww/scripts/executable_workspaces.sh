#!/bin/sh
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

render() {
  hyprctl --batch "j/activeworkspace ; j/workspaces" | jq -rs '
    .[0].id as $a
    | .[1]
    | map(select(.id > 0 and .id <= 5))
    | sort_by(.id)
    | map(if .id == $a then "[\(.id)]" else " \(.id) " end)
    | join(" ")
  '
}

render
socat -u "UNIX-CONNECT:$SOCK" - | while IFS= read -r line; do
  case "$line" in
  workspace* | activeworkspace* | focusedmon* | createworkspace* | destroyworkspace* | moveworkspace* | renameworkspace*)
    render
    ;;
  esac
done
