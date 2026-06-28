_: {
  flake.nixosModules.nixpkgs = {
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
}
