{ config, pkgs, lib, ... }:

let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.meta) getExe;

  inherit (config.local) user;
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
      XDG_CONFIG_HOME = "${user.home}/.config";
      XDG_CACHE_HOME = "${user.home}/.cache";
      XDG_DATA_HOME = "${user.home}/.local/share";
      XDG_STATE_HOME = "${user.home}/.local/state";

      EDITOR = "x";
      VISUAL = "x";
      SUDO_EDITOR = "x";
      PAGER = "bat";
      BAT_PAGER = "ov -F -H3";
      MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
      SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
      SYSTEMD_PAGERSECURE = "false";
    };

    variables = {
      CARGO_HOME = "${user.home}/.local/share/cargo";
      RUSTUP_HOME = "${user.home}/.local/share/rustup";
      NPM_CONFIG_INIT_MODULE = "${user.home}/.config/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${user.home}/.cache/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      RIPGREP_CONFIG_PATH = "${user.home}/.config/ripgrep/config";
    };
  };

  programs = {
    fish.enable = true;
    nano.enable = false;
  };
}
