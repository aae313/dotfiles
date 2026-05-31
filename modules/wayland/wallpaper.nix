{ pkgs, lib, ... }:
let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/d6/wallhaven-d6j79o.png";
    hash = "sha256-4nFo0PPlESqoFWZhEtA9JvFnOChOIxxcZq/FqiYNfCw=";
  };

  wallpaperCommand = pkgs.writeShellApplication {
    name = "wallpaper";
    text = /* bash */ ''
      exec ${getExe pkgs.swaybg} -i ${wallpaper} -m fill
    '';
  };
in
{
  environment.systemPackages = singleton wallpaperCommand;
}
