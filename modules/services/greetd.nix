{
  config,
  lib,
  ...
}:
{
  services.greetd =
    let
      inherit (lib.meta) getExe';

      session = {
        command = getExe' config.programs.niri.package "niri-session";
        user = "wasd";
      };
    in
    {
      enable = true;
      restart = false;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };
}
