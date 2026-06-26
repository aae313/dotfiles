#!/usr/bin/env nu

use lib/helix.nu

def main [
  start_path: string = ""
  workspace_dir: string = ""
  hx_cwd: string = ""
]: nothing -> nothing {
  let cwd = if $workspace_dir != "" and ($workspace_dir | path exists) {
    $workspace_dir
  } else if $hx_cwd != "" and ($hx_cwd | path exists) {
    $hx_cwd
  } else {
    $env.PWD
  }

  let start = if $start_path != "" and ($start_path | path exists) {
    $start_path
  } else {
    $cwd
  }

  let chooser = (mktemp --tmpdir hx-yazi.XXXXXXXXXX | str trim)

  let zellij_args = [
    "run"
    "--block-until-exit"
    "--close-on-exit"
    "--cwd" $cwd
    "--floating"
    "--x" "10%"
    "--y" "10%"
    "--width" "80%"
    "--height" "80%"
    "--name" "hx-yazi"
    "--"
    "yazi"
    $"--chooser-file=($chooser)"
    $start
  ]

  try {
    ^zellij ...$zellij_args
  } catch {
    rm --force $chooser
    print --stderr "error: zellij/yazi failed"
    exit 1
  }

  let files = try {
    open --raw $chooser | lines | where {|p| $p != "" }
  } catch {
    []
  }

  rm -f $chooser

  if ($files | is-empty) {
    exit 0
  }

  helix open-files ...$files
}
