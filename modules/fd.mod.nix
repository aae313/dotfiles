_: {
  flake.nixosModules.fd =
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
        packages = singleton pkgs.fd;

        xdg.config.files."fd/ignore".text = ''
          .git/
          .jj/
          .cache/
          .build/
          .target/

        '';
      };
    };
}
