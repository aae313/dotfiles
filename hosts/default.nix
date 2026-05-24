{
  nixpkgs,
  self,
  ...
}:
let
  inherit (self) inputs;
in
{
  light = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      { networking.hostName = "light"; }
      ./light
      ../modules
    ];
    specialArgs = {
      inherit inputs;
    };
  };
}
