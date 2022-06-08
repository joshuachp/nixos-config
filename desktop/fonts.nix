{ config
, pkgs
, lib
, flake-utils
, nerd-font-symbols
, ...
}:
let
  system = flake-utils.lib.system.x86_64-linux;
  nerd-font-symbols-pkg = nerd-font-symbols.defaultPackage.${system};
in
{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      jetbrains-mono

      # Symbols
      nerd-font-symbols-pkg

      # Microsoft fonts
      corefonts
    ];

    enableDefaultFonts = true;
    fontDir.enable = true;

    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" "Symbols Nerd Font" ];
    };
  };
}
