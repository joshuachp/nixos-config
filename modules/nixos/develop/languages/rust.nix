# Rust develop config
{ self
, config
, pkgs
, lib
, ...
}:
let
  cfg = config.systemConfig.develop;
in
{
  config = lib.mkIf cfg.enable (
    let
      toolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-analyzer" "rust-src" ];
      };
    in
    {
      environment.systemPackages = import "${self}/pkgs/develop/rust.nix" { inherit pkgs toolchain; };
      environment.variables.RUST_SRC_PATH = "${toolchain}";
    }
  );
}
