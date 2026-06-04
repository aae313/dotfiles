#!/usr/bin/env nu

def dispatch [expr: string] {
    ^hyprctl dispatch $expr | ignore
}

def active_address [] {
    ^hyprctl activewindow -j | from json | get address
}

let workspace = (^hyprctl activeworkspace -j | from json)
if $workspace.tiledLayout != "master" {
    exit 0
}

let original_address = active_address

let tiled_clients = (
    ^hyprctl clients -j
    | from json
    | where mapped
    | where floating == false
    | where workspace.id == $workspace.id
    | insert area { |client| $client.size.0 * $client.size.1 }
    | sort-by area
)

let master_address = ($tiled_clients | last | get address)

let clients = (
    $tiled_clients
    | where address != $master_address
    | where { |client| (($client.grouped? | default []) | length) == 0 }
    | sort-by { get at.1 } { get at.0 }
)

if ($clients | length) < 2 {
    dispatch $"hl.dsp.focus\(\{ window = 'address:($original_address)' \}\)"
    exit 0
}

let seed = ($clients | first)
dispatch $"hl.dsp.focus\(\{ window = 'address:($seed.address)' \}\)"
dispatch 'hl.dsp.group.toggle()'

for client in ($clients | skip 1) {
    dispatch $"hl.dsp.focus\(\{ window = 'address:($client.address)' \}\)"
    dispatch 'hl.dsp.window.move({ into_group = "r" })'
}

dispatch $"hl.dsp.focus\(\{ window = 'address:($original_address)' \}\)"
