_: {
  flake.nixosModules.git =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name} = {
        packages = [
          pkgs.gh
          pkgs.gitMinimal
        ];

        xdg.config.files."git/config".text = /* ini */ ''
          [user]
              email = ${user.email}
              name = ${user.handle}
              signingkey = "${user.home}/.ssh/id_ed25519.pub"
          [color]
            ui = auto
          [core]
              preloadIndex = true
          [commit]
              verbose = true
          [alias]
              co = checkout
              br = branch
              ci = commit
              st = status
          [init]
              defaultBranch = main
          [diff]
              external = difft
              tool = difftastic
          [merge]
            conflictstyle = zdiff3
          [difftool "difftastic"]
              cmd = difft "$LOCAL" "$REMOTE"
          [difftool]
              prompt = false

          [pager]
              difftool = true
          [fetch]
              fsckObjects = true
          [credential]
              helper = store

          [url "ssh://git@github.com/"]
              insteadOf = "https://github.com/"
        '';
      };
    };
}
