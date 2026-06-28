_: {
  flake.nixosModules.wallpaper =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      inherit (config.local) user;

      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/k8/wallhaven-k8kke7.png";
        hash = "sha256-GEWUwbGza2nyQ2cNg2dFDGyo8Ey5ORWQyTTuNpSkHCo=";
      };

      wallpaperCommand = pkgs.writeShellApplication {
        name = "wallpaper";
        text = /* bash */ ''
          exec ${getExe pkgs.swaybg} --image ${wallpaper} --mode fill
        '';
      };
    in
    {
      hjem.users.${user.name}.systemd.services.wallpaper = {
        description = "Set the desktop wallpaper";
        after = singleton "graphical-session.target";
        partOf = singleton "graphical-session.target";
        wantedBy = singleton "graphical-session.target";
        serviceConfig = {
          ExecStart = getExe wallpaperCommand;
          Restart = "on-failure";
        };
      };
    };
}
