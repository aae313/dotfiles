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
      environment.systemPackages = singleton pkgs.fd;

      hjem.users.${user.name}.xdg.config.files."fd/ignore".text = ''
        .git/
        .jj/
        .cache/
        .build/
        .target/

      '';
    };
}
