{ inputs, ... }:
{
  flake.nixosModules.ai-tools =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      environment.systemPackages = [
        pkgs.antigravity
        pkgs.opencode
        inputs.claude-code-nix.packages.${system}.default
        inputs.codex-cli-nix.packages.${system}.default
      ];
    };
}
