{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (pkgs.stdenv.hostPlatform) system;

  hyprland = inputs.hyprland.packages.${system}.hyprland.override {
    stdenv = pkgs.ccacheStdenv;
  };
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = false;
    package = hyprland;
  };

  environment.systemPackages = singleton inputs.pyprland.packages.${system}.pyprland;
}
