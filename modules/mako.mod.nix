_: {
  flake.nixosModules.mako =
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
      inherit (config.local.theme) fonts palette;
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.mako;

        systemd.services.mako = {
          description = "Mako notification daemon";
          after = singleton "graphical-session.target";
          partOf = singleton "graphical-session.target";
          wantedBy = singleton "graphical-session.target";
          serviceConfig = {
            ExecStart = getExe pkgs.mako;
            Restart = "on-failure";
          };
        };

        xdg.config.files."mako/config".text = /* ini */ ''
          font=${fonts.mono} 9
          width=420
          height=110
          padding=10
          border-size=2
          border-radius=5
          anchor=top-right
          default-timeout=5000

          background-color=#${palette.bgMain}
          text-color=#${palette.fgMain}
          border-color=#${palette.blue}
          progress-color=over #${palette.bgInactive}

          [urgency=high]
          border-color=#${palette.red}
          background-color=#${palette.bgRedNuanced}
        '';
      };
    };
}
