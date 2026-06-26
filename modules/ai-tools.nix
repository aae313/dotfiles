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
  environment.systemPackages = [
    pkgs.antigravity
    pkgs.opencode
    inputs.claude-code-nix.packages.${system}.default
    inputs.codex-cli-nix.packages.${system}.default
  ];
}
