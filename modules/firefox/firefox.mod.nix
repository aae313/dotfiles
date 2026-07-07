{ config, inputs, ... }:
let
  inherit (config.flake) packages;
in
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
      hjem.users.${user.name}.xdg.config.files = {
        "mozilla/firefox/hey/chrome/userChrome.css".source = ./userChrome.css;
        "mozilla/firefox/hey/user.js".source = ./user.js;
      };

      programs.firefox = {
        enable = true;
        package = inputs.firefox-nightly.packages.${system}.firefox-nightly-bin;
        nativeMessagingHosts.packages = singleton packages.${system}.tridactyl-native;

        policies = {
          DontCheckDefaultBrowser = true;
          DisablePocket = true;
          DisableAppUpdate = true;
        };
      };
    };
}
