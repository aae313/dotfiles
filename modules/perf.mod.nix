_: {
  flake.nixosModules.perf =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      environment.systemPackages = singleton pkgs.perf;

      # Allow unprivileged kernel+user profiling (default 2 is user-space only).
      boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
    };
}
