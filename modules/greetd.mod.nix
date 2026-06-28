_: {
  flake.nixosModules.greetd =
    { config, lib, ... }:
    let
      inherit (lib.meta) getExe';

      inherit (config.local) user;

      session = {
        command = getExe' config.programs.niri.package "niri-session";
        user = user.name;
      };
    in
    {
      services.greetd = {
        enable = true;
        # restart = false;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };
    };
}
