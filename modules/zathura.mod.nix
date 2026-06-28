_: {
  flake.nixosModules.zathura =
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
      environment.systemPackages = singleton pkgs.zathura;

      hjem.users.${user.name}.xdg.config.files."zathura/zathurarc".text = ''
        set selection-clipboard clipboard
        set font "JetBrains Mono 12"
      '';
    };
}
