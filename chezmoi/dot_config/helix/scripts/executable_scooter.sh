#!/usr/bin/env bash
set -euo pipefail

selection=""

if [[ "${1:-}" == "--selection" ]]; then
  selection="$(cat)"
  shift
fi

root="$(jj workspace root 2>/dev/null || pwd)"

args=(scooter)

if [[ -n "$selection" ]]; then
  args+=(--fixed-strings)
  if [[ "$selection" == *$'\n'* ]]; then
    args+=(--multiline)
  fi
  args+=(--search-text "$selection")
fi

args+=("$root")

zellij run \
  -c \
  -f \
  --cwd "$root" \
  -x 10% \
  -y 10% \
  --width 80% \
  --height 80% \
  --name scooter \
  -- "${args[@]}" >/dev/null
