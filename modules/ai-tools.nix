{
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;

  inherit (config.local) user;
in

{
  environment.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${user.home}/.config/claude";
    CODEX_HOME = "${user.home}/.config/codex";
  };

  environment.systemPackages = [
    pkgs.antigravity
    pkgs.opencode
    inputs.claude-code-nix.packages.${system}.default
    inputs.codex-cli-nix.packages.${system}.default
  ];
}
