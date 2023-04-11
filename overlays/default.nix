# Default overlays for all systems
{ system
, jump
, tools
, note
, pulseaudioMicState
, fenix
, nixpkgs-unstable
, ...
}: {
  config =
    let
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixpkgs.overlays = [
        fenix.overlays.default

        (self: super: {
          inherit (pkgsUnstable) qemu OVMFFull;

          nerdfonts = super.nerdfonts.override {
            # Only the symbols are needed
            fonts = [ "NerdFontsSymbolsOnly" ];
          };

          jumpOverlay = jump.packages.${system}.default;
          rust-toolsOverlay = tools.packages.${system}.rust-tools;
          shell-toolsOverlay = tools.packages.${system}.shell-tools;
          noteOverlay = note.packages.${system}.default;
          pulseaudioMicStateOverlay = pulseaudioMicState.packages.${system}.default;
        })
      ];
    };
}
