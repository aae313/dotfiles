#!/bin/bash
# ~/.config/mango/scripts/screenshot.sh

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

case "${1:-full}" in
    full)
        # Full screen
        grim "$FILENAME"
        ;;
    area)
        # Select area
        grim -g "$(slurp)" "$FILENAME"
        ;;
    window)
        # Current window geometry
        GEOMETRY=$(mmsg -g -x | awk '
            /^x/ {x=$3}
            /^y/ {y=$3}
            /^width/ {w=$3}
            /^height/ {h=$3}
            END {printf "%d,%d %dx%d", x, y, w, h}
        ')
        grim -g "$GEOMETRY" "$FILENAME"
        ;;
    edit)
        # Screenshot and edit
        grim -g "$(slurp)" - | satty --filename - --output-filename "$FILENAME"
        ;;
esac

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
fi
