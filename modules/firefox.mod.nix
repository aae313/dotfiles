{ inputs, ... }:
{
  flake.nixosModules.firefox =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;

      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      nixpkgs.overlays = singleton (
        final: _previous: {
          tridactyl-native = final.callPackage ../packages/tridactyl-native { };
        }
      );

      services.psd = {
        enable = true;
        resyncTimer = "10m";
      };

      programs.firefox = {
        enable = true;
        package = inputs.firefox-nightly.packages.${system}.firefox-nightly-bin;
        nativeMessagingHosts.packages = singleton pkgs.tridactyl-native;

        policies = {
          DontCheckDefaultBrowser = true;
          DisablePocket = true;
          DisableAppUpdate = true;
        };
      };
    };
}
