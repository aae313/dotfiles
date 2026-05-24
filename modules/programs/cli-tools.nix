{ pkgs, inputs, ... }:

{
  environment = {
    localBinInPath = true;

    systemPackages = [
      pkgs.atuin
      pkgs.ast-grep
      pkgs.bash-language-server
      pkgs.bat
      pkgs.btop
      pkgs.chezmoi
      pkgs.claude-code
      pkgs.scooter
      pkgs.direnv
      pkgs.difftastic
      pkgs.eza
      pkgs.fd
      pkgs.ffmpeg
      pkgs.file
      pkgs.fish-lsp
      pkgs.fzf
      pkgs.gcc
      pkgs.glow
      pkgs.hexyl
      pkgs.hyperfine
      pkgs.jq
      pkgs.just
      pkgs.just-lsp
      pkgs.kdlfmt
      pkgs.ov
      pkgs.libqalculate
      pkgs.lsof
      pkgs.lua-language-server
      pkgs.markdown-toc
      pkgs.markdownlint-cli2
      pkgs.marksman
      pkgs.man-db
      pkgs.nil
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
      pkgs.tree-sitter
      pkgs.usbutils
      pkgs.util-linux
      pkgs.vscode-langservers-extracted
      pkgs.xdg-terminal-exec
      pkgs.yazi
      pkgs.zoxide
      pkgs.starship
      pkgs.zellij
      pkgs.python3
      pkgs.nushell

      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  environment.sessionVariables = {
    EDITOR = "nv";
    VISUAL = "nv";
    SUDO_EDITOR = "env -u NVIM_LISTEN_ADDRESS nvim";
    PAGER = "bat";
    BAT_PAGER = "ov -F -H3";
    MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";
    SYSTEMD_PAGER = "bat -l syslog -p --strip-ansi=auto";
    SYSTEMD_PAGERSECURE = "false";
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/config";
  };

  system.activationScripts.chezmoiConfig.text = /* bash */ ''
    configDir=/home/wasd/.config/chezmoi
    config="$configDir/chezmoi.toml"
    sourceLine='sourceDir = "/home/wasd/.local/share/nixos"'

    ${pkgs.coreutils}/bin/install -d -m0755 -o wasd -g users "$configDir"

    if ! ${pkgs.coreutils}/bin/test -e "$config"; then
      ${pkgs.coreutils}/bin/install -Dm0644 -o wasd -g users /dev/null "$config"
    fi

    if ${pkgs.gnugrep}/bin/grep -qxF "$sourceLine" "$config"; then
      :
    elif ${pkgs.gnugrep}/bin/grep -q '^sourceDir[[:space:]]*=' "$config"; then
      ${pkgs.gnused}/bin/sed -i "s|^sourceDir[[:space:]]*=.*|$sourceLine|" "$config"
    else
      ${pkgs.coreutils}/bin/printf '\n%s\n' "$sourceLine" >> "$config"
    fi

    ${pkgs.coreutils}/bin/chown wasd:users "$config"
    ${pkgs.coreutils}/bin/chmod 0644 "$config"
  '';
}
