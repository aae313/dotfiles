_: {
  flake.nixosModules.cliphist =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe getExe';

      inherit (config.local) user;

      wlPaste = getExe' pkgs.wl-clipboard "wl-paste";
      cliphist = getExe pkgs.cliphist;

      watcher = type: {
        description = "Watch the clipboard and store ${type} entries in cliphist";
        after = singleton "graphical-session.target";
        partOf = singleton "graphical-session.target";
        wantedBy = singleton "graphical-session.target";
        serviceConfig = {
          ExecStart = "${wlPaste} --type ${type} --watch ${cliphist} store";
          Restart = "on-failure";
        };
      };
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.cliphist;

        systemd.services.cliphist-text = watcher "text";
        systemd.services.cliphist-image = watcher "image";
      };
    };
}
