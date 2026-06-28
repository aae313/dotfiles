_: {
  flake.nixosModules.scripts =
    {
      config,
      lib,
      relativeTo,
      ...
    }:
    let
      inherit (lib.attrsets) listToAttrs nameValuePair;
      inherit (lib.filesystem) listFilesRecursive;

      inherit (config.local) user;

      # Enumerate names from the flake copy, but link to the live working tree so
      # script edits take effect without a rebuild. `source` is a string,
      # which hjem links out-of-store as-is.
      src = ../scripts;
      dir = "${user.home}/nixos/scripts";
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
