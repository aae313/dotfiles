{ config, inputs, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
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
      imports = singleton inputs.niri.nixosModules.niri;

      nixpkgs.overlays = [
        inputs.niri.overlays.niri
        (final: previous: {
          nirius = previous.nirius.overrideAttrs (
            finalAttrs: _previousAttrs: {
              version = "0.8.0";

              src = final.fetchFromSourcehut {
                owner = "~tsdh";
                repo = "nirius";
                rev = "5708cbd8a22b6e8b8073fcf5bffc8069477a145b";
                hash = "sha256-hLrGdeRDhNC7xyG0IIQN1A+O8WzqIZqIRZ04fkLfANs=";
              };

              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit (finalAttrs) pname src version;
                hash = "sha256-3d/U5xsOPV5XzZuLNvkV4BYCfzrpFCol5p8Ras3eCn8=";
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
