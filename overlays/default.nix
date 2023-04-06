# Default overlays for all systems
{ system
, jump
, tools
, note
, pulseaudioMicState
, fenix
, ...
}: {
  config = {
    nixpkgs.overlays = [
      fenix.overlays.default

      (self: super: {
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
