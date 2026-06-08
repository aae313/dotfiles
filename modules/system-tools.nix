{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.app2unit
    pkgs.carapace
    pkgs.direnv
    pkgs.ffmpeg
    pkgs.file
    pkgs.fish
    pkgs.libqalculate
    pkgs.nushell
    pkgs.pciutils
    pkgs.psmisc
    pkgs.socat
    pkgs.sysstat
    pkgs.usbutils
    pkgs.util-linux
    pkgs.xdg-terminal-exec
  ];
}
