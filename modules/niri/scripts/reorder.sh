#!/usr/bin/env bash
set -euo pipefail

want=(kitty firefox-nightly)

get_id() {
	local app_id=$1

	niri msg --json windows |
		jq -r --arg app_id "$app_id" '
			.[] |
			select(.app_id == $app_id) |
			select(.is_floating == false) |
			.id
		' |
		head -n1
}

for app in "${want[@]}"; do
	id=$(get_id "$app")

	if [[ ! $id =~ ^[0-9]+$ ]]; then
		echo "Could not find tiling window with app_id: $app" >&2
		exit 1
	fi

	ids+=("$id")
done

niri msg action focus-window --id "${ids[0]}"
niri msg action move-column-to-index 1

niri msg action focus-window --id "${ids[1]}"
niri msg action move-column-to-index 2

niri msg action focus-window --id "${ids[0]}"
