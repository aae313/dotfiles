{ pkgs, lib, ... }:

let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.meta) getExe;
in

{
  environment = {
    localBinInPath = true;

    shells = [
      pkgs.fish
      pkgs.nushell
    ];

    shellAliases = genAttrs [ "ls" "ll" "l" ] (_: null);

    sessionVariables = {
      SHELL = getExe pkgs.fish;
      XDG_CONFIG_HOME = "/home/wasd/.config";
      XDG_CACHE_HOME = "/home/wasd/.cache";
      XDG_DATA_HOME = "/home/wasd/.local/share";
      XDG_STATE_HOME = "/home/wasd/.local/state";

      EDITOR = "nv";
      VISUAL = "nv";
      PAGER = "bat";
      BAT_PAGER = "ov -F -H3";
      MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
      SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
      SYSTEMD_PAGERSECURE = "false";
    };

    variables = {
      CARGO_HOME = "/home/wasd/.local/share/cargo";
      RUSTUP_HOME = "/home/wasd/.local/share/rustup";
      NPM_CONFIG_INIT_MODULE = "/home/wasd/.config/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "/home/wasd/.cache/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      RIPGREP_CONFIG_PATH = "/home/wasd/.config/ripgrep/config";
    };
  };

  programs = {
    fish.enable = true;
    nano.enable = false;
  };
}
