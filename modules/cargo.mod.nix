_: {
  flake.nixosModules.cargo =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.xdg.data.files."cargo/config.toml".text = /* toml */ ''
        # [target.x86_64-unknown-linux-gnu]
        # linker = "clang"
        # rustflags = ["-C", "link-arg=-fuse-ld=mold"]

        # [build]
        # rustc-wrapper = "sccache"
      '';
    };
}
