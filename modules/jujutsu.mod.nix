_: {
  flake.nixosModules.jujutsu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.local) user;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      hjem.users.${user.name} = {
        packages = [
          pkgs.jjui
          pkgs.jujutsu
          pkgs.mergiraf
        ];

        xdg.config.files."jj/config.toml".generator = pkgs.writers.writeTOML "jj-config.toml";
        xdg.config.files."jj/config.toml".value = {
          user.email = user.email;
          user.name = user.handle;

          aliases = {
            ",," = [
              "edit"
              "@+"
            ];
            ".." = [
              "edit"
              "@-"
            ];

            a = singleton "abandon";

            c = singleton "commit";
            ci = [
              "commit"
              "--interactive"
            ];

            cl = [
              "git"
              "clone"
            ];

            d = singleton "diff";

            e = singleton "edit";

            f = [
              "git"
              "fetch"
            ];

            i = [
              "git"
              "init"
            ];

            l = singleton "log";
            la = [
              "log"
              "--revisions"
              "::"
            ];

            p = [
              "git"
              "push"
            ];

            r = singleton "rebase";

            res = singleton "resolve";

            resa = singleton "resolve-ast";
            resolve-ast = [
              "resolve"
              "--tool"
              "${getExe pkgs.mergiraf}"
            ];

            s = singleton "squash";

            sh = singleton "show";

            si = [
              "squash"
              "--interactive"
            ];

            u = singleton "undo";
          };

          git.push = "origin";
          git.sign-on-push = true;

          merge-tools.mergiraf.program = getExe pkgs.mergiraf;

          remotes."*".auto-track-bookmarks = "${user.handle}/*";

          revsets.bookmark-advance-to = /* jj-revset */ ''
            heads(::@ & ~description(exact:"") & (~empty() | merges()))
          '';

          revsets.log = /* jj-revset */ ''
            present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
          '';

          signing = {
            backend = "ssh";
            behavior = "drop";
            key = "${user.home}/.ssh/id_ed25519.pub";
          };

          ui = {
            conflict-marker-style = "snapshot";
            default-command = "log";
            diff-editor = ":builtin";
            diff-formatter = [
              (getExe pkgs.difftastic)
              "--color"
              "always"
              "$left"
              "$right"
            ];
            merge-editor = getExe pkgs.mergiraf;

            graph.style = "square";
          };
        };
      };
    };
}
