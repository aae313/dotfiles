_: {
  flake.nixosModules.gdb =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name} = {
        xdg.config.files."gdb/gdbinit".source = ../files/.config/gdb/gdbinit;
        files.".gdbinit.d/init".source = ../files/.gdbinit.d/init;
      };
    };
}
