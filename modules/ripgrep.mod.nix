_: {
  flake.nixosModules.ripgrep =
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
      environment.variables.RIPGREP_CONFIG_PATH = "${user.home}/.config/ripgrep/config";

      environment.systemPackages = singleton pkgs.ripgrep;

      hjem.users.${user.name}.xdg.config.files."ripgrep/config".text = ''
        --smart-case
        --glob=!{/proc,*.lock}
      '';
    };
}
