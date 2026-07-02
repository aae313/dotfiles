{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets)
    attrNames
    attrValues
    listToAttrs
    nameValuePair
    removeAttrs
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) subtractLists;
  inherit (lib.path) removePrefix;
  inherit (lib.strings) concatStringsSep;

  # Keys are computed with `lib.path.removePrefix` (string stripping would leak
  # store paths under impure eval).
  relativeTo = root: path: lib.strings.removePrefix "./" (removePrefix root path);
in
{
  flake.lib = {
    mkHost =
      {
        hostName,
        kernelPackages,
        excludeModules ? [ ],
        extraModules ? [ ],
      }:
      let
        unknownModules = subtractLists (attrNames config.flake.nixosModules) excludeModules;
      in
      assert assertMsg (unknownModules == [ ])
        "mkHost ${hostName}: excludeModules names unknown modules: ${concatStringsSep " " unknownModules}";
      inputs.nixpkgs.lib.nixosSystem {
        modules =
          attrValues (removeAttrs config.flake.nixosModules excludeModules)
          ++ [
            { networking.hostName = hostName; }
            ({ pkgs, ... }: { boot.kernelPackages = kernelPackages pkgs; })
          ]
          ++ extraModules;
      };

    inherit relativeTo;

    # Shared linker so a config subtree living next to its module can be
    # adopted without enumerating each file:
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
}
