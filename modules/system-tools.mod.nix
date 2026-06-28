_: {
  flake.nixosModules.system-tools =
    { config, pkgs, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.packages = [
        pkgs.app2unit
        pkgs.carapace
        pkgs.direnv
        pkgs.ffmpeg
        pkgs.file
        pkgs.libqalculate
        pkgs.nushell
        pkgs.socat
        pkgs.xdg-terminal-exec
      ];

      environment.systemPackages = [
        pkgs.pciutils
        pkgs.psmisc
        pkgs.sysstat
        pkgs.usbutils
        pkgs.util-linux
      ];
    };
}
