{ inputs, ... }:
{
  flake.nixosModules.firefox =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (pkgs.stdenv.hostPlatform) system;

      inherit (config.local) user;
    in
    {
      nixpkgs.overlays = singleton (
        final: _previous: {
          tridactyl-native = final.callPackage ../../packages/tridactyl-native { };
        }
      );

      hjem.users.${user.name}.xdg.config.files."mozilla/firefox/hey/user.js".source = ./user.js;

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
