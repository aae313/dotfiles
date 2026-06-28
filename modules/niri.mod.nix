{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
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

      environment.systemPackages = [
        pkgs.nirius
        pkgs.xwayland-satellite-unstable
      ];

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
