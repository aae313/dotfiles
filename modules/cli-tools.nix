{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
    pkgs.bat
    pkgs.btop
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.glow
    pkgs.hexyl
    pkgs.hyperfine
    pkgs.jc
    pkgs.jq
    pkgs.lsof
    pkgs.numbat
    pkgs.ov
    pkgs.procs
    pkgs.ripgrep
    pkgs.rsync
    pkgs.scooter
    pkgs.tlrc
    pkgs.yazi
    pkgs.zellij
    pkgs.zoxide
    pkgs.difftastic
  ];
}
