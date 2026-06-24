{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
in
{
  imports = [
    ./amd.nix
    ./blacklist.nix
    ./bluetooth.nix
  ];

  environment.systemPackages = singleton pkgs.ddcutil;

  hardware.graphics.enable = true;
}
