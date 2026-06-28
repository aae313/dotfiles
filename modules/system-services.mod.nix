_: {
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
}
