{
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe';

  session = {
    command = getExe' config.programs.mango.package "mango";
    user = "wasd";
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
}
