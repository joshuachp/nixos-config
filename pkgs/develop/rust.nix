{ pkgs, toolchain }: with pkgs; [
  toolchain

  sccache

  cargo-criterion
  cargo-edit
  cargo-tarpaulin
  cargo-watch
  cargo-nextest
  cargo-hack
  cargo-semver-checks

  bacon
]
