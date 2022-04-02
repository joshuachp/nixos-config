{
  pkgs,
  lib,
  fenix,
  ...
}: {
  nixpkgs.overlays = [fenix.overlay];
  environment.systemPackages = with pkgs; [
    (pkgs.fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])

    rust-analyzer
    cargo-criterion
  ];
}
