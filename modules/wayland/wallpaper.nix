{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/d6/wallhaven-d6j79o.png";
    hash = "sha256-4nFo0PPlESqoFWZhEtA9JvFnOChOIxxcZq/FqiYNfCw=";
  };
in
{
  systemd.user.services.swaybg = {
    description = "Wallpaper";
    after = singleton "graphical-session.target";
    partOf = singleton "graphical-session.target";
    wantedBy = singleton "graphical-session.target";

    serviceConfig = {
      ExecStart = "${getExe pkgs.swaybg} -i ${wallpaper} -m fill";
      Restart = "on-failure";
    };
  };
}
