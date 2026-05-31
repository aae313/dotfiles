{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = false;
    package = inputs.hyprland.packages.${system}.hyprland;
  };

  environment.systemPackages = singleton inputs.pyprland.packages.${system}.pyprland;
}
