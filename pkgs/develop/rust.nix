{ pkgs }: with pkgs; [
  (pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])
  sccache
  rust-analyzer

  cargo-criterion
  cargo-edit
  cargo-tarpaulin
  cargo-watch
  cargo-nextest

  bacon
]
