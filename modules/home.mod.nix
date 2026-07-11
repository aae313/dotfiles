{ inputs, ... }:
{
  flake.nixosModules.home =
    { config, lib, ... }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
    in
    {
      imports = singleton inputs.hjem.nixosModules.hjem;

      hjem.clobberByDefault = true;

      hjem.extraModules = singleton inputs.hjem-rum.hjemModules.default;

      hjem.users.${user.name}.enable = true;
    };
}
