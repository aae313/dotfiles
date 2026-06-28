_: {
  flake.nixosModules.version-control =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.gh
        pkgs.gitMinimal
        pkgs.jjui
        pkgs.jujutsu
        pkgs.mergiraf
      ];
    };
}
