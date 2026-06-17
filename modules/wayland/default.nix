{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.niri.nixosModules.niri
    ./greetd.nix
    ./notifications.nix
    ./session.nix
    ./tools.nix
    ./wallpaper.nix
    ./xdg.nix
  ];

  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (final: prev: {
      nirius = prev.nirius.overrideAttrs (
        finalAttrs: _previousAttrs: {
          version = "0.7.3";

          src = final.fetchFromSourcehut {
            owner = "~tsdh";
            repo = "nirius";
            rev = "nirius-${finalAttrs.version}";
            hash = "sha256-Il/TmvLMOdKsSRH8OkVpHaNQQAgmIRzC9xYvlsPmAKA=";
          };

          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) pname src version;
            hash = "sha256-jLT+RGOdI5L3UEc+z71WhS+mo9OlBPLauyj7Sv/25hE=";
          };
        }
      );
    })
  ];

  environment.systemPackages = [
    pkgs.nirius
    pkgs.xwayland-satellite-unstable
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
