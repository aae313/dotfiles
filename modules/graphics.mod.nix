_: {
  flake.nixosModules.graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.packages = singleton pkgs.ddcutil;

      hardware.graphics.enable = true;
    };
}
