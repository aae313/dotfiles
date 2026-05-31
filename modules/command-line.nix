{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  inherit (lib.meta) getExe;
in

{
  environment = {
    localBinInPath = true;

    systemPackages = [
      pkgs.ast-grep
      pkgs.bash-language-server
      pkgs.bat
      pkgs.btop
      pkgs.claude-code
      pkgs.scooter
      pkgs.direnv
      pkgs.difftastic
      pkgs.eza
      pkgs.fd
      pkgs.ffmpeg
      pkgs.file
      pkgs.fish
      pkgs.fzf
      pkgs.gcc
      pkgs.gitMinimal
      pkgs.glow
      pkgs.hexyl
      pkgs.hyperfine
      pkgs.jq
      pkgs.just
      pkgs.just-lsp
      pkgs.jujutsu
      pkgs.jjui
      pkgs.mergiraf
      pkgs.kdlfmt
      pkgs.ov
      pkgs.libqalculate
      pkgs.lsof
      pkgs.shellcheck
      pkgs.lua-language-server
      pkgs.nil
      pkgs.nixd
      pkgs.helix
      pkgs.nix-index
      pkgs.nirius
      pkgs.nix-direnv
      pkgs.nixfmt
      pkgs.pciutils
      pkgs.prettier
      pkgs.procs
      pkgs.psmisc
      pkgs.ripgrep
      pkgs.rsync
      pkgs.shfmt
      pkgs.statix
      pkgs.stylua
      pkgs.sysstat
      pkgs.app2unit
      pkgs.taplo
      pkgs.tombi
      pkgs.tree-sitter
      pkgs.usbutils
      pkgs.util-linux
      pkgs.nufmt
      pkgs.vscode-langservers-extracted
      pkgs.xdg-terminal-exec
      pkgs.yazi
      pkgs.zoxide
      pkgs.zellij
      pkgs.python3
      pkgs.carapace

      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  environment.sessionVariables = {
    SHELL = getExe pkgs.nushell;
    XDG_STATE_HOME = "/home/wasd/.local/state";
    CARGO_HOME = "/home/wasd/.local/share/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    HISTFILE = "/home/wasd/.local/state/bash/history";
    EDITOR = getExe pkgs.helix;
    VISUAL = getExe pkgs.helix;
    SUDO_EDITOR = getExe pkgs.helix;
    PAGER = "bat";
    BAT_PAGER = "ov -F -H3";
    MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
    SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
    SYSTEMD_PAGERSECURE = "false";
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/config";
  };

}
