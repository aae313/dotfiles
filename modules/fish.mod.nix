_: {
  flake.nixosModules.fish =
    {
      config,
      linkConfigDir,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      programs.fish.enable = true;

      hjem.users.${user.name}.xdg.config.files = linkConfigDir "fish";
    };
}
