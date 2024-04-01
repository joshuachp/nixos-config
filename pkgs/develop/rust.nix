{ pkgs, toolchain }: with pkgs; [
  toolchain

  sccache

  cargo-audit
  cargo-criterion
  cargo-edit
  cargo-hack
  cargo-nextest
  cargo-semver-checks
  cargo-tarpaulin
  cargo-watch

  bacon
]
