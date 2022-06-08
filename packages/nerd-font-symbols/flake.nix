{
  description = "NerdFonts Symbols";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages = flake-utils.lib.flattenTree {
        nerd-font-symbols =
          let
            version = "2.1.0";
            fileName = "Nerd-Fonts-Symbols.ttf";
            src = pkgs.fetchurl {
              name = fileName;
              url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v${version}/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf";
              sha256 = "sha256-VpnnL91Bq5e8Hnhu9sCoskGOiDiAxWEDvuiKRB23Hh0=";
            };
          in
          pkgs.stdenv.mkDerivation {
            inherit version;
            inherit src;

            pname = "nerd-font-symbols";

            dontUnpack = true;

            sourceRoute = ".";

            installPhase = ''
              install -D ${src} $out/share/fonts/truetype/NerdFonts/${fileName}
            '';

            meta = {
              description = "Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts";
              longDescription = ''
                Nerd Fonts is a project that attempts to patch as many developer targeted
                and/or used fonts as possible. The patch is to specifically add a high
                number of additional glyphs from popular 'iconic fonts' such as Font
                Awesome, Devicons, Octicons, and others.
              '';
              homepage = "https://nerdfonts.com/";
              license = pkgs.lib.licenses.mit;
            };
          };
      };
      defaultPackage = self.packages.${system}.nerd-font-symbols;
    });
}
