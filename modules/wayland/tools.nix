{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.cliphist
    pkgs.fuzzel
    pkgs.libnotify
    pkgs.wl-clipboard
  ];
}
