{ config
, pkgs
, lib
, fenix
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])

    rust-analyzer
    cargo-criterion
    cargo-edit

    bacon
    sccache
  ]);
}
