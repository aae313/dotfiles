_: {
  flake.nixosModules.documentation =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      documentation = {
        enable = true;
        dev.enable = true;
        doc.enable = false;
        nixos.enable = false;
        info.enable = false;
        man.enable = true;
      };

      environment.systemPackages = singleton pkgs.man-pages;
    };
}
