{ ... }:
let
  session = {
    command = "/run/current-system/sw/bin/niri-session";
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
