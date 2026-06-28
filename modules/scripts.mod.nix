_: {
  flake.nixosModules.scripts =
    {
      config,
      linkExecutableDir,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.files = linkExecutableDir ".local/bin";
    };
}
