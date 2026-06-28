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

      filesRoot = ../files;
      configRoot = ../files/.config;

      relativeTo = root: path: lib.strings.removePrefix "./" (lib.path.removePrefix root path);
    in
    {
      imports = singleton inputs.hjem.nixosModules.hjem;

      hjem.clobberByDefault = true;

      hjem.users.${user.name}.enable = true;

      # Shared linkers exposed to every program module so a config subtree can be
      # adopted without enumerating each file. Home-relative keys are computed with
      # `lib.path.removePrefix` (string stripping would leak store paths under
      # impure eval).
      _module.args = {
        # files/.config/<name>/** -> xdg.config.files, keyed relative to ~/.config.
        linkConfigDir =
          name:
          listToAttrs (
            map (path: nameValuePair (relativeTo configRoot path) { source = path; }) (
              listFilesRecursive (configRoot + "/${name}")
            )
          );

        # files/<dir>/** -> files, keyed relative to $HOME and marked executable.
        linkExecutableDir =
          dir:
          listToAttrs (
            map
              (path: nameValuePair (relativeTo filesRoot path) {
                source = path;
                executable = true;
              })
              (listFilesRecursive (filesRoot + "/${dir}"))
          );
      };
    };
}
