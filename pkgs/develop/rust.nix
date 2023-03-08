{ pkgs }: with pkgs; [
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

  sccache
  bacon
]
