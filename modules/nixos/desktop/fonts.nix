{ config
, pkgs
, lib
, flake-utils
, nerd-font-symbols
, system
, ...
}: {
  config = {
    fonts = {
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra

        dejavu_fonts

        jetbrains-mono

        # Microsoft fonts
        corefonts

        # Symbols
        nerdfonts
      ];

      enableDefaultFonts = true;
      fontDir.enable = true;

      fontconfig.defaultFonts = {
        monospace = [ "JetBrains Mono Nerd Font" "JetBrains Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" "Symbols Nerd Font" ];
      };
    };
  };
}
