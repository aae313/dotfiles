#!/usr/bin/env fish

set input (printf "45\n50\n55\n60\n65\n" | fuzzel --dmenu --prompt="mfact: ")

test -z "$input"; and exit 0

if not string match -qr '^[0-9]+$' -- "$input"
    notify-send "Invalid mfact" "Use a percentage like 55"
    exit 1
end

set factor (math "$input / 100")

hyprctl dispatch "hl.dsp.layout('mfact exact $factor')"
