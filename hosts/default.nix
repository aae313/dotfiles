{
  nixpkgs,
  self,
  ...
}:
let
  inherit (self) inputs;

  mkHost =
    name:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { networking.hostName = name; }
        ./${name}
        ../modules
      ];
      specialArgs = {
        inherit inputs;
      };
    };
in
{
  light = mkHost "light";

  golden-wind = mkHost "golden-wind";
}
