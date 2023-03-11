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

  sccache
  bacon
]
