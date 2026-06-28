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
          user.email = "230780735+aae313@users.noreply.github.com";
          user.name = "aae313";

          aliases.",," = [
            "edit"
            "@+"
          ];
          aliases.".." = [
            "edit"
            "@-"
          ];

          aliases.a = [ "abandon" ];

          aliases.c = [ "commit" ];
          aliases.ci = [
            "commit"
            "--interactive"
          ];

          aliases.cl = [
            "git"
            "clone"
          ];

          aliases.d = [ "diff" ];

          aliases.e = [ "edit" ];

          aliases.f = [
            "git"
            "fetch"
          ];

          aliases.i = [
            "git"
            "init"
          ];

          aliases.l = [ "log" ];
          aliases.la = [
            "log"
            "--revisions"
            "::"
          ];

          aliases.p = [
            "git"
            "push"
          ];

          aliases.r = [ "rebase" ];

          aliases.res = [ "resolve" ];

          aliases.resa = [ "resolve-ast" ];
          aliases.resolve-ast = [
            "resolve"
            "--tool"
            "${getExe pkgs.mergiraf}"
          ];

          aliases.s = [ "squash" ];

          aliases.sh = [ "show" ];

          aliases.si = [
            "squash"
            "--interactive"
          ];

          aliases.u = [ "undo" ];

          git.push = "origin";
          git.sign-on-push = true;

          merge-tools.mergiraf.program = getExe pkgs.mergiraf;

          remotes."*".auto-track-bookmarks = "aae313/*";

          revsets.bookmark-advance-to = ''
            heads(::@ & ~description(exact:"") & (~empty() | merges()))
          '';

          revsets.log = ''
            present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)
          '';

          signing.backend = "ssh";
          signing.behavior = "drop";
          signing.key = "~/.ssh/id_ed25519.pub";

          ui.conflict-marker-style = "snapshot";
          ui.default-command = "log";
          ui.diff-editor = ":builtin";
          ui.diff-formatter = [
            "difft"
            "--color"
            "always"
            "$left"
            "$right"
          ];
          ui.merge-editor = getExe pkgs.mergiraf;

          ui.graph.style = "square";
        };
      };
    };
}
