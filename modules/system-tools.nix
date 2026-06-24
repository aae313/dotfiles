{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.app2unit
    pkgs.carapace
    pkgs.direnv
    pkgs.ffmpeg
    pkgs.file
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
