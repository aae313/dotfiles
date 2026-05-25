{ lib, ... }:
let
  inherit (lib.lists) singleton;
in
{
  services = {
    fstrim.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = singleton "/nix";
    };
  };
}
