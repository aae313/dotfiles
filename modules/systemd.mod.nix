_: {
  flake.nixosModules.systemd = {
    systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

    systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";
  };
}
