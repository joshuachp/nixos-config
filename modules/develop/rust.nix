{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      (pkgs.fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])

      sccache

      rust-analyzer
      bacon

      cargo-criterion
      cargo-edit
    ];
  };
}
