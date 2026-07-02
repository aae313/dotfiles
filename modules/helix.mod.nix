{ inputs, ... }:
{
  flake.nixosModules.helix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe hiPrio;

      inherit (config.local) user;
      inherit (pkgs.stdenv.hostPlatform) system;

      helix = inputs.helix.packages.${system}.default.override {
        includeGrammarIf = _: false;
      };
    in
    {
      hjem.users.${user.name}.packages = [
        helix

        (
          hiPrio
          <| pkgs.writeShellScriptBin "hx" /* bash */ ''
            printf '\033]1337;SetUserVar=in_editor=MQ==\007'

            ${getExe helix} "$@"
            status=$?

            printf '\033]1337;SetUserVar=in_editor\007'

            exit "$status"
          ''
        )
      ];
    };
}
