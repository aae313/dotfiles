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
      pkgs.scooter
      pkgs.direnv
      pkgs.difftastic
      pkgs.eza
      pkgs.fd
      pkgs.ffmpeg
      pkgs.file
      pkgs.fish
      pkgs.fish-lsp
      pkgs.fzf
      pkgs.gcc
      pkgs.gitMinimal
      pkgs.glow
      pkgs.helix
      pkgs.hexyl
      pkgs.hyperfine
      pkgs.jq
      pkgs.just
      pkgs.just-lsp
      pkgs.jujutsu
      pkgs.gh
      pkgs.jjui
      pkgs.mergiraf
      pkgs.kdlfmt
      pkgs.ov
      pkgs.libqalculate
      pkgs.lsof
      pkgs.socat
      pkgs.shellcheck
      pkgs.nil
      pkgs.nixd
      pkgs.nix-index
      pkgs.nix-direnv
      pkgs.nixfmt
      pkgs.nushell
      pkgs.pciutils
      pkgs.prettier
      pkgs.procs
      pkgs.psmisc
      pkgs.ripgrep
      pkgs.rsync
      pkgs.shfmt
      pkgs.statix
      pkgs.starship
      pkgs.sysstat
      pkgs.app2unit
      pkgs.taplo
      pkgs.tlrc
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
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.antigravity
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  environment.sessionVariables = {
    SHELL = getExe pkgs.fish;
    XDG_STATE_HOME = "/home/wasd/.local/state";
    CARGO_HOME = "/home/wasd/.local/share/cargo";
    RUSTUP_HOME = "/home/wasd/.local/share/rustup";
    HISTFILE = "/home/wasd/.local/state/bash/history";
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
    PAGER = "bat";
    BAT_PAGER = "ov -F -H3";
    MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
    SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
    SYSTEMD_PAGERSECURE = "false";
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/config";
  };

}
