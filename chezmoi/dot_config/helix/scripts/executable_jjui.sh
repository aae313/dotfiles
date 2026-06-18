#!/usr/bin/env bash
set -euo pipefail

root="$(jj workspace root 2>/dev/null || pwd)"

zellij run \
  -c \
  -f \
  --cwd "$root" \
  -x 10% \
  -y 10% \
  --width 80% \
  --height 80% \
  --name jjui \
  -- jjui "$root" >/dev/null
