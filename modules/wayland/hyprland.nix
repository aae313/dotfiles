{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = [
    pkgs.eww
    pkgs.grim
    pkgs.satty
    pkgs.slurp
    inputs.pyprland.packages.${system}.pyprland
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
}
