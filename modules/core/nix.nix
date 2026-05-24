{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkDefault mkForce;
  inherit (lib.types) isType;
in
{

  documentation = {
    enable = false;
    dev.enable = true;
    doc.enable = false;
    nixos.enable = false;
    info.enable = false;
    man = {
      enable = mkDefault false;
    };
  };

  nixpkgs = {
    overlays = singleton inputs.cachyos-kernel.overlays.pinned;
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  nix = {

    package = pkgs.lixPackageSets.latest.lix;
    registry = mapAttrs (_: flake: { inherit flake; }) <| filterAttrs (_: isType "flake") inputs;

    settings = {
      sandbox = false;
      use-xdg-base-directories = true;
      flake-registry = "/etc/nix/registry.json";

      max-jobs = "auto";
      http-connections = 128;
      max-substitution-jobs = 128;
      builders-use-substitutes = mkForce true;

      keep-derivations = true;
      keep-outputs = true;

      log-lines = 25;

      accept-flake-config = true;
      use-cgroups = true;

      allowed-users = singleton "@wheel";
      trusted-users = [
        "root"
        "wasd"
      ];

      system-features = [
        "gccarch-znver4"
        "kvm"
        "ca-derivations"
        "recursive-nix"
        "big-parallel"
      ];

      keep-going = true;

      warn-dirty = false;

      auto-optimise-store = true;

      experimental-features = [
        "flakes"
        "nix-command"
        "cgroups"
        "pipe-operator"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://vicinae.cachix.org"
        "https://cache.garnix.io"
        "https://attic.xuyh0120.win/lantian"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
  };

  system.stateVersion = "26.05";
}
