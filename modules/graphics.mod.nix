_: {
  flake.nixosModules.graphics =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      environment.systemPackages = singleton pkgs.ddcutil;

      hardware.graphics.enable = true;
    };
}
