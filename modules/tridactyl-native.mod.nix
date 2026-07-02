_: {
  perSystem =
    { pkgs, ... }:
    {
      packages.tridactyl-native = pkgs.callPackage ../packages/tridactyl-native { };
    };
}
