# Default overlays for all systems
{ system, flakeInputs, ... }:
{
  imports = [ ./pkgs.nix ];
  config =
    let
      inherit (flakeInputs)
        jump
        nixosAnywhere
        note
        rust-overlay
        tools
        ;
    in
    {
      nixpkgs.overlays = [
        rust-overlay.overlays.default

        (self: super: {
          nerdfonts = super.nerdfonts.override {
            # Only the symbols are needed
            fonts = [
              "JetBrainsMono"
              "NerdFontsSymbolsOnly"
            ];
          };

          jumpOverlay = jump.packages.${system}.default;
          noteOverlay = note.packages.${system}.default;
          rust-toolsOverlay = tools.packages.${system}.rust-tools;
          shell-toolsOverlay = tools.packages.${system}.shell-tools;

          nixos-anywhere = nixosAnywhere.packages.${system}.default;
        })
      ];
    };
}
