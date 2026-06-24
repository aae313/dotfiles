{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./greetd.nix
    ./notifications.nix
    ./session.nix
    ./tools.nix
    ./wallpaper.nix
    ./xdg.nix
  ];

  environment.systemPackages = [
    inputs.pyprland.packages.${system}.pyprland
    inputs.snappy-switcher.packages.${system}.default
  ];

  programs.hyprland.enable = true;
}
