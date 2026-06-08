{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
  inherit (lib.types) isType;
in
{
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = false;
    nixos.enable = false;
    info.enable = false;
    man = {
      enable = true;
    };
  };

  environment.systemPackages = singleton pkgs.man-pages;

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  nixpkgs.overlays = [
    inputs.nixpkgs-wayland.overlay
  ];

  nix = {
    package = pkgs.lixPackageSets.git.lix;
    registry = mapAttrs (_: flake: { inherit flake; }) <| filterAttrs (name: flake: name != "self" && isType "flake" flake) inputs;

    settings = {
      sandbox = false;
      use-xdg-base-directories = true;
      flake-registry = "/etc/nix/registry.json";

      max-jobs = "auto";
      http-connections = 128;
      max-substitution-jobs = 128;
      builders-use-substitutes = mkForce true;

      keep-derivations = true;
      keep-outputs = false;

      log-lines = 25;

      accept-flake-config = true;
      use-cgroups = true;

      allowed-users = singleton "@wheel";
      trusted-users = [
        "root"
        "wasd"
      ];

      system-features = [
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
        "https://attic.xuyh0120.win/lantian"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
        "https://claude-code.cachix.org"
      ];

      trusted-substituters = [
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      ];
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = [ ];
  };

  programs.nh = {
    enable = true;
    flake = "/home/wasd/.local/share/nixos";
  };
}
