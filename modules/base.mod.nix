_: {
  flake.nixosModules.base =
    {
      lib,
      modulesPath,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkDefault;
    in
    {
      imports = singleton <| modulesPath + "/installer/scan/not-detected.nix";

      nixpkgs.hostPlatform = mkDefault "x86_64-linux";

      system.stateVersion = "26.05";
    };
}
