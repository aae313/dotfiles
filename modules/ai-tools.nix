{
  inputs,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in

{
  environment.sessionVariables = {
    CLAUDE_CONFIG_DIR = "/home/wasd/.config/claude";
    CODEX_HOME = "/home/wasd/.config/codex";
  };

  environment.systemPackages = [
    pkgs.antigravity
    pkgs.opencode
    inputs.claude-code-nix.packages.${system}.default
    inputs.codex-cli-nix.packages.${system}.default
  ];
}
