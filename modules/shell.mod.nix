_: {
  flake.nixosModules.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) genAttrs;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      inherit (config.local) user;
    in
    {
      environment = {
        localBinInPath = true;

        shells = singleton pkgs.fish;

        shellAliases = genAttrs [ "ls" "ll" "l" ] (_: null);

        sessionVariables = {
          SHELL = getExe pkgs.fish;
          XDG_CONFIG_HOME = "${user.home}/.config";
          XDG_CACHE_HOME = "${user.home}/.cache";
          XDG_DATA_HOME = "${user.home}/.local/share";
          XDG_STATE_HOME = "${user.home}/.local/state";

          EDITOR = "nvim";
          VISUAL = "nvim";
          SUDO_EDITOR = "nvim";
        };

        variables = {
          CARGO_HOME = "${user.home}/.local/share/cargo";
          RUSTUP_HOME = "${user.home}/.local/share/rustup";
          NPM_CONFIG_INIT_MODULE = "${user.home}/.config/npm/config/npm-init.js";
          NPM_CONFIG_CACHE = "${user.home}/.cache/npm";
          NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
        };
      };

      programs.nano.enable = false;
    };
}
