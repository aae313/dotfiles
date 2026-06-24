{
  inputs,
  lib,
  ...
}:
let
  inherit (lib.lists) singleton;
in
{
  nixpkgs.overlays = singleton inputs.nix-cachyos-kernel.overlays.pinned;
}
