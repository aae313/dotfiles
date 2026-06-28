_: {
  flake.nixosModules.ov =
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
      environment.sessionVariables.MANPAGER = "ov --section-delimiter '^[^\\s]' --section-header";

      hjem.users.${user.name} = {
        packages = singleton pkgs.ov;

        # Kept as a source file: the upstream theme indents its top-level keys, which
        # Nix indented-string stripping would not preserve faithfully.
        xdg.config.files."ov/config.yaml".source = ./config.yaml;
      };
    };
}
