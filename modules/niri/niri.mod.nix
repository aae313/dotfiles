{ inputs, ... }:
{
  flake.nixosModules.niri =
    {
      config,
      lib,
      linkConfigDir,
      pkgs,
      ...
    }:
    let
      inherit (lib.strings) optionalString;

      inherit (config.local) user;

      niriConfig = /* kdl */ ''
        include "input.kdl"
        ${optionalString (config.networking.hostName == "light") ''include "outputs.kdl"''}
        include "appearance.kdl"
        include "binds.kdl"
        include "rules.kdl"
        include "misc.kdl"
      '';
    in
    {
      imports = [ inputs.niri.nixosModules.niri ];

      nixpkgs.overlays = [
        inputs.niri.overlays.niri
        (final: previous: {
          nirius = previous.nirius.overrideAttrs (
            finalAttrs: _previousAttrs: {
              version = "0.7.3-unstable-2026-06-22";

              src = final.fetchFromSourcehut {
                owner = "~tsdh";
                repo = "nirius";
                rev = "f924d407c01b3f12e630d2d07ec281e203efc341";
                hash = "sha256-UYfY/ogIUuk9+qhPfky9jjLONY7otF+2msP2pY/Fruk=";
              };

              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit (finalAttrs) pname src version;
                hash = "sha256-jLT+RGOdI5L3UEc+z71WhS+mo9OlBPLauyj7Sv/25hE=";
              };
            }
          );
        })
      ];

      hjem.users.${user.name} = {
        packages = [
          pkgs.nirius
          pkgs.xwayland-satellite-unstable
        ];

        xdg.config.files = linkConfigDir ./config "niri" // {
          "niri/config.kdl".text = niriConfig;
        };
      };

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
