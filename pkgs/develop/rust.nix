{ pkgs }: with pkgs; [
  (pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])

  rust-analyzer
  cargo-criterion
  cargo-edit
  cargo-tarpaulin

  sccache
  bacon
]
