_: {
  flake.nixosModules.glow =
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
      hjem.users.${user.name} = {
        packages = singleton pkgs.glow;

        xdg.config.files."glow/glow.yml".text = /* yaml */ ''
          style: "dark"
          # mouse support (TUI-mode only)
          mouse: false
          # use pager to display markdown
          pager: true
          # word-wrap at width
          width: 100
          # show all files, including hidden and ignored.
          all: false
        '';
      };
    };
}
