{ inputs, ... }:
{
  flake.nixosModules.cli-tools =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      environment.systemPackages = [
        inputs.hunk.packages.${system}.hunk
        pkgs.btop
        pkgs.fzf
        pkgs.hexyl
        pkgs.hyperfine
        pkgs.jc
        pkgs.jq
        pkgs.lsof
        pkgs.numbat
        pkgs.rsync
        pkgs.scooter
        pkgs.zoxide
        pkgs.difftastic
        inputs.helix.packages.${system}.default
      ];
    };
}
