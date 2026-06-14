{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.cliphist
    pkgs.dex
    pkgs.fuzzel
    pkgs.libnotify
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.satty
  ];
}
