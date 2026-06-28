_: {
  flake.nixosModules.eza =
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
      hjem.users.${user.name} = {
        packages = singleton pkgs.eza;

        xdg.config.files."eza/theme.yml".source = ./theme.yml;
      };
    };
}
