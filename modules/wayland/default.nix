{ inputs, ... }:
{
  imports = [
    inputs.mangowm.nixosModules.mango
    ./greetd.nix
    ./notifications.nix
    ./session.nix
    ./tools.nix
    ./wallpaper.nix
    ./xdg.nix
  ];

  programs.mango.enable = true;
}
