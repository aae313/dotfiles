{ inputs, ... }:
{
  flake.nixosModules.cli-tools =
    { config, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;

      inherit (config.local) user;
    in
    {
      programs.ydotool.enable = true;
      hjem.users.${user.name}.packages = [
        inputs.hunk.packages.${system}.hunk
        pkgs.btop
        pkgs.hexyl
        pkgs.hyperfine
        pkgs.jc
        pkgs.jq
        pkgs.lsof
        pkgs.numbat
        pkgs.rsync
        pkgs.scooter
        pkgs.difftastic
      ];
    };
}
