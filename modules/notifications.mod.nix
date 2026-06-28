_: {
  flake.nixosModules.notifications =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      environment.systemPackages = singleton pkgs.mako;

      systemd.user.services.mako = {
        description = "Mako notification daemon";
        after = singleton "graphical-session.target";
        partOf = singleton "graphical-session.target";
        wantedBy = singleton "graphical-session.target";
        serviceConfig = {
          ExecStart = getExe pkgs.mako;
          Restart = "on-failure";
        };
      };
    };
}
