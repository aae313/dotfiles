_: {
  flake.nixosModules.fuzzel =
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
      environment.systemPackages = singleton pkgs.fuzzel;

      hjem.users.${user.name}.xdg.config.files."fuzzel/fuzzel.ini".text = /* ini */ ''
        [main]
        font=JetBrainsMono Nerd Font:size=14
        terminal=footclient -e
        layer=overlay
        launch-prefix='app2unit --fuzzel-compat --'
        prompt='>> '
        width=60
        lines=20
        line-height=24
        vertical-pad=8
        horizontal-pad=14
        inner-pad=8

        [colors]
        background=#000000ff
        text=#ffffffff
        message=#c6daffff
        prompt=#2fafffff
        placeholder=#989898ff
        input=#ffffffff
        match=#d0bc00ff
        selection=#2f447fff
        selection-text=#ffffffff
        selection-match=#d0bc00ff
        counter=#989898ff
        border=#2fafffff

        [dmenu]
        exit-immediately-if-empty=yes

        [border]
        width=2
        radius=0
      '';
    };
}
