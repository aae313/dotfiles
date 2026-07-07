{ inputs, ... }:
{
  flake.nixosModules.hyprland =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      imports = singleton inputs.hyprland.nixosModules.default;

      environment = {
        systemPackages = [ pkgs.pyprland ];
        variables = {
          APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        };
      };

      # nixpkgs.overlays = singleton (
      #   final: previous: {
      #     pyprland = previous.pyprland.overrideAttrs (
      #       finalAttrs: _previousAttrs: {
      #         version = "3.4.3";
      #
      #         src = final.fetchFromGitHub {
      #           owner = "hyprland-community";
      #           repo = "pyprland";
      #           tag = finalAttrs.version;
      #           hash = "sha256-/CR07do2Ma9DYmQ3dNwaXYZmgIX4gQdVMdtEz+AM78E=";
      #         };
      #       }
      #     );
      #   }
      # );

      programs = {
        hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          portalPackage =
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          withUWSM = true;
        };
        uwsm.enable = true;
      };
    };
}
