{ config, ... }:
let
  inherit (config.flake.lib) relativeTo;
in
{
  flake.nixosModules.scripts =
    { config, lib, ... }:
    let
      inherit (lib.attrsets) listToAttrs nameValuePair;
      inherit (lib.filesystem) listFilesRecursive;

      inherit (config.local) user;
      src = ../scripts;
      dir = "${user.flakeDir}/scripts";
    in
    {
      hjem.users.${user.name}.files = listToAttrs (
        map (
          path:
          let
            rel = relativeTo src path;
          in
          nameValuePair ".local/bin/${rel}" {
            type = "symlink";
            source = "${dir}/${rel}";
            executable = true;
          }
        ) (listFilesRecursive src)
      );
    };
}
