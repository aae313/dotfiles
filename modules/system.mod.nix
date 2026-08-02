_: {
  flake.nixosModules.logging = {
    services.journald.settings.Journal = {
      SystemMaxUse = "50M";
      RuntimeMaxUse = "10M";
    };
  };

  flake.nixosModules.system-services =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      services = {
        dbus.implementation = "broker";
        getty.autologinUser = user.name;
        syslogd.tty = "tty4";
      };
    };

  flake.nixosModules.systemd = {
    systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
    systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";
  };
}
