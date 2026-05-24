{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
in

{
  environment.systemPackages = singleton pkgs.zathura;
}
