_: {
  flake.nixosModules.gdb =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name} = {
        xdg.config.files."gdb/gdbinit".source = ./gdbinit;
        files.".gdbinit.d/init".source = ./gdbinit.d/init;
      };
    };
}
