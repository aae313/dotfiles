{
  inputs,
  pkgs,
  ...
}:
let
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
    policies = {
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      DisableAppUpdate = true;
    };
  };
}
