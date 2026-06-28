{ inputs, ... }:
{
  flake.nixosModules.home =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib.attrsets) listToAttrs nameValuePair;
      inherit (lib.filesystem) listFilesRecursive;
      inherit (lib.lists) singleton;

      inherit (config.local) user;

      relativeTo = root: path: lib.strings.removePrefix "./" (lib.path.removePrefix root path);
    in
    {
      imports = singleton inputs.hjem.nixosModules.hjem;

      hjem.clobberByDefault = true;

      hjem.users.${user.name}.enable = true;

      # Shared linker exposed to every program module so a config subtree living
      # next to its module can be adopted without enumerating each file. Keys are
      # computed with `lib.path.removePrefix` (string stripping would leak store
      # paths under impure eval).
      _module.args = {
        inherit relativeTo;

        # <src>/** -> xdg.config.files, keyed under <dest>/. `src` is a path
        # literal supplied by the caller, so it resolves to that module's own
        # directory.
        linkConfigDir =
          src: dest:
          listToAttrs (
            map (path: nameValuePair "${dest}/${relativeTo src path}" { source = path; }) (
              listFilesRecursive src
            )
          );
      };
    };
}
