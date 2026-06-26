{ pkgs, lib, ... }:
let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  # wallpaper = pkgs.fetchurl {
  #   url = "https://w.wallhaven.cc/full/2y/wallhaven-2y2wg6.png";
  #   hash = "sha256-nFoNfk7Y/CGKWtscOE5GOxshI5eFmppWvhxHzOJ6mCA=";
  # };

  wallpaperCommand = pkgs.writeShellApplication {
    name = "wallpaper";
    # text = /* bash */ ''
    #   exec ${getExe pkgs.swaybg} -i ${wallpaper} -m fill
    # '';
    text = ''
      exec ${getExe pkgs.swaybg} -c '#000000'
    '';
  };
in
{
  environment.systemPackages = singleton wallpaperCommand;
}
