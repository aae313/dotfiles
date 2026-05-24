{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gitMinimal
    pkgs.jujutsu
  ];
}
