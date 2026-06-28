{ inputs, ... }:
{
  flake.nixosModules.ai-tools =
    { config, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;

      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.packages = [
        pkgs.antigravity
        pkgs.opencode
        inputs.claude-code-nix.packages.${system}.default
        inputs.codex-cli-nix.packages.${system}.default
      ];
    };
}
