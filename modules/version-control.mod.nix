_: {
  flake.nixosModules.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.local) user;
      inherit (lib.meta) getExe;
    in
    {
      hjem.users.${user.name} = {
        packages = [
          pkgs.gh
          pkgs.gitMinimal
        ];

        rum.programs.git = {
          enable = true;
          package = null;
          settings = {
            user = {
              inherit (user) email;
              name = user.handle;
              signingkey = "${user.home}/.ssh/id_ed25519.pub";
            };
            color.ui = "auto";
            core.preloadIndex = true;
            commit.verbose = true;
            alias = {
              co = "checkout";
              br = "branch";
              ci = "commit";
              st = "status";
            };
            init.defaultBranch = "main";
            diff = {
              external = getExe pkgs.difftastic;
              tool = "difftastic";
            };
            merge.conflictstyle = "zdiff3";
            "difftool \"difftastic\"".cmd = ''${getExe pkgs.difftastic} "$LOCAL" "$REMOTE"'';
            difftool.prompt = false;
            pager.difftool = true;
            fetch.fsckObjects = true;
            credential.helper = "store";
            "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
          };
        };
      };
    };
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

        xdg.config.files."jj/config.toml" = {
          generator = pkgs.writers.writeTOML "jj-config.toml";
          value = {
            user = {
              inherit (user) email;
              name = user.handle;
            };

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
                "mergiraf"
              ];

              s = singleton "squash";

              sh = singleton "show";

              si = [
                "squash"
                "--interactive"
              ];

              u = singleton "undo";
            };

            git = {
              push = "origin";
              sign-on-push = true;
            };

            merge-tools.mergiraf.program = getExe pkgs.mergiraf;

            remotes."*".auto-track-bookmarks = "${user.handle}/*";

            revsets = {
              bookmark-advance-to = /* jj-revset */ ''
                heads(::@ & ~description(exact:"") & (~empty() | merges()))
              '';

              log = /* jj-revset */ ''
                present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
              '';
            };

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
    };
}
