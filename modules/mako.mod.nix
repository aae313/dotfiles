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

      hjem.users.${user.name}.xdg.config.files."mako/config".text = /* ini */ ''
        font=JetBrainsMono Nerd Font 9
        width=420
        height=110
        padding=10
        border-size=2
        border-radius=5
        anchor=top-right
        default-timeout=5000
        # Modus colors

        background-color=#000000
        text-color=#ffffff
        border-color=#2fafff
        progress-color=over #303030

        [urgency=high]
        border-color=#ff5f59
        background-color=#3a0c14
      '';
    };
}
