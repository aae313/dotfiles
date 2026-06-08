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
      SHELL = getExe pkgs.nushell;
      XDG_CONFIG_HOME = "/home/wasd/.config";
      XDG_CACHE_HOME = "/home/wasd/.cache";
      XDG_STATE_HOME = "/home/wasd/.local/state";

      EDITOR = "x";
      VISUAL = "x";
      SUDO_EDITOR = "hx";
      PAGER = "bat";
      BAT_PAGER = "ov -F -H3";
      MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
      SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
      SYSTEMD_PAGERSECURE = "false";
    };

    variables = {
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      NPM_CONFIG_INIT_MODULE = "$XDG_CONFIG_HOME/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      RIPGREP_CONFIG_PATH = "$XDG_CONFIG_HOME/ripgrep/config";
    };
  };

  programs = {
    fish.enable = true;
    nano.enable = false;
  };
}
