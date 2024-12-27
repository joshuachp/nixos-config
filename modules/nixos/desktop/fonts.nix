# Font configuration
{
  pkgs,
  ...
}:
{
  config = {
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-extra

        atkinson-hyperlegible
        inter
        jetbrains-mono

        # Microsoft fonts
        corefonts

        # Symbols
        nerdfonts
      ];

      enableDefaultPackages = true;
      fontDir.enable = true;

      fontconfig.defaultFonts = {
        monospace = [
          "JetBrains Mono Nerd Font Mono"
          "JetBrains Mono"
        ];
        sansSerif = [
          "Atkinson Hyperlegible"
          "Noto Sans"
        ];
        serif = [ "Noto Serif" ];
        emoji = [
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
      };
    };
  };
}
