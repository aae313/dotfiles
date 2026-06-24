{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;

  inherit (pkgs.stdenv.hostPlatform) system;
in
{
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
}
