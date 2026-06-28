{ inputs, ... }: {
  flake.nixosModules.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
      inherit (config.local.theme) fonts;
    in
    {
      programs.neovim = {
        enable = true;
        package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
        vimAlias = true;
        viAlias = true;
      };

      environment.systemPackages = singleton pkgs.neovide;

      hjem.users.${user.name}.xdg.config.files."neovide/config.toml" = {
        generator = pkgs.writers.writeTOML "neovide-config.toml";
        value = {
          fork = true;
          frame = "full";
          idle = true;
          "no-multigrid" = false;
          theme = "auto";
          "title-hidden" = true;
          vsync = true;
          wsl = false;

          font = {
            normal = [
              fonts.mono
              "Noto Color Emoji"
            ];
            size = 12;
          };
        };
      };
    };

}
