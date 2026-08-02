_: {
  flake.nixosModules.system-tools =
    { config, pkgs, ... }:
    let
      inherit (config.local) user;

      # Remove once nixpkgs#548360 reaches this flake's nixpkgs revision.
      app2unit = pkgs.app2unit.overrideAttrs (
        finalAttrs: _previousAttrs: {
          version = "1.4.4";

          src = pkgs.fetchFromGitHub {
            owner = "Vladimir-csp";
            repo = "app2unit";
            tag = "v${finalAttrs.version}";
            hash = "sha256-TIY+/9ekGub+10uyqXy5aYU+2NLysMtaQnD1PIjBCFA=";
          };
        }
      );
    in
    {
      hjem.users.${user.name}.packages = [
        app2unit
        pkgs.carapace
        pkgs.ffmpeg
        pkgs.file
        pkgs.libqalculate
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
