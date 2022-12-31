# Default overlays for all systems
self: super: {
  nerdfonts = super.nerdfonts.override {
    # Only the symbols are needed
    fonts = [ "NerdFontsSymbolsOnly" ];
  };
}
