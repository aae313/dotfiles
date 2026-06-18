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

  golden-wind = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      { networking.hostName = "golden-wind"; }
      ./golden-wind
      ../modules
    ];
    specialArgs = {
      inherit inputs;
    };
  };
}
