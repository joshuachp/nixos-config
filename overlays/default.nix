# Default overlays for all systems
{ system
, flakeInputs
, ...
}: {
  config =
    let
      inherit (flakeInputs) jump tools note pulseaudioMicState fenix nixpkgs-unstable nil
        nixosAnywhere;
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixpkgs.overlays = [
        fenix.overlays.default

        (self: super: {
          inherit (pkgsUnstable) qemu OVMFFull;

          nerdfonts = super.nerdfonts.override {
            # Only the symbols are needed
            fonts = [
              "JetBrainsMono"
              "NerdFontsSymbolsOnly"
            ];
          };

          jumpOverlay = jump.packages.${system}.default;
          rust-toolsOverlay = tools.packages.${system}.rust-tools;
          shell-toolsOverlay = tools.packages.${system}.shell-tools;
          noteOverlay = note.packages.${system}.default;
          pulseaudioMicStateOverlay = pulseaudioMicState.packages.${system}.default;

          nil = nil.packages.${system}.default;
          nixos-anywhere = nixosAnywhere.packages.${system}.default;

          astartectl =
            let
              version = "22.11.02";
            in
            pkgsUnstable.buildGoModule {
              inherit version;
              pname = "astartectl";
              src = pkgsUnstable.fetchFromGitHub {
                owner = "astarte-platform";
                repo = "astartectl";
                rev = "v${version}";
                sha256 = "sha256-24KzPxbewf/abzqQ7yf6HwFQ/ovJeMCrMNYDfVn5HA8=";
              };
              vendorSha256 = "sha256-RVWnkbLOXtNraSoY12KMNwT5H6KdiQoeLfRCLSqVwKQ=";
              # Completion
              nativeBuildInputs = with pkgsUnstable; [
                installShellFiles
              ];
              postInstall = ''
                installShellCompletion --cmd astartectl \
                  --bash <($out/bin/astartectl completion bash) \
                  --zsh <($out/bin/astartectl completion zsh)
              '';
            };
        })
      ];
    };
}
