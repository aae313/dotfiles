{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ast-grep
    pkgs.bash-language-server
    pkgs.fish-lsp
    pkgs.gcc
    pkgs.just
    pkgs.just-lsp
    pkgs.kdlfmt
    pkgs.lua-language-server
    pkgs.nil
    pkgs.nix-direnv
    pkgs.nix-index
    pkgs.nixd
    pkgs.nixfmt
    pkgs.nu-lint
    pkgs.nufmt
    pkgs.prettier
    pkgs.python3
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.statix
    pkgs.stylua
    pkgs.taplo
    pkgs.tombi
    pkgs.tree-sitter
    pkgs.vscode-langservers-extracted
  ];
}
