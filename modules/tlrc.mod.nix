_: {
  flake.nixosModules.tlrc =
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
      environment.systemPackages = singleton pkgs.tlrc;

      hjem.users.${user.name}.xdg.config.files."tlrc/config.toml".text = /* toml */ ''
        [cache]
        dir = "~/.local/share/tldr"
        auto_update = true
        defer_auto_update = false
        max_age = 336
        # languages = ["de", "pl"]

        [output]
        show_title = true
        platform_title = false
        show_hyphens = false
        edit_link = false
        example_prefix = "- "
        line_length = 0
        compact = false
        option_style = "long"
        raw_markdown = false

        [indent]
        title = 2
        description = 2
        bullet = 2
        example = 4

        # [style.title]
        # color = "magenta"
        # bold = true

        # [style.description]
        # color = "magenta"

        # [style.bullet]
        # color = "green"

        # [style.example]
        # color = "cyan"

        # [style.url]
        # color = "red"
        # italic = true

        # [style.inline_code]
        # color = "yellow"
        # italic = true

        # [style.placeholder]
        # color = "red"
        # italic = true
      '';
    };
}
