{ config, pkgs, lib, ... }: {

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      jetbrains-mono
      # nerdfonts

      # Microsoft fonts
      corefonts
    ];

    enableDefaultFonts = true;
    fontDir.enable = true;

    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

}
