{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
    ./greetd.nix
    ./notifications.nix
    ./session.nix
    ./tools.nix
    ./wallpaper.nix
    ./xdg.nix
  ];

  environment.systemPackages = [
    pkgs.nirius
    pkgs.xwayland-satellite-unstable
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
