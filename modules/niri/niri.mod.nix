{
  config,
  inputs,
  ...
}:
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

      inherit (config.local) user;
    in
    {
      imports = singleton inputs.niri.nixosModules.niri;

      environment.variables.APP2UNIT_SLICES =
        "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";

      nixpkgs.overlays = singleton inputs.niri.overlays.niri;

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      services.dbus.packages = singleton pkgs.nautilus;

      hjem.users.${user.name} = {
        packages = [
          pkgs.nautilus
          pkgs.nirius
          pkgs.xwayland-satellite-unstable
        ];

        files = {
          ".local/bin/niri-static-scratchpad" = {
            source = ./bin/niri-static-scratchpad;
            executable = true;
          };

          ".local/bin/niri-toggle-center-focused-column" = {
            source = ./bin/niri-toggle-center-focused-column;
            executable = true;
          };
        };

        xdg.config.files = linkConfigDir ./config "niri" // {
          "niri/appearance.kdl" = {
            type = "copy";
            source = ./config/appearance.kdl;
          };

          "niri/input-output.kdl".text = /* kdl */ ''
            include "input.kdl"
            include "outputs-${config.networking.hostName}.kdl"
          '';
        };
      };
    };
}
