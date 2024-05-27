# Font configuration
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.systemConfig.desktop;
in
{
  config = lib.mkMerge [
    # Console configuration
    {
      console = {
        earlySetup = true;
        font = "Lat2-Terminus16";
      };
    }
    # Desktop configuration
    (lib.mkIf cfg.enable {
      fonts = {
        packages = with pkgs; [
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

        enableDefaultPackages = true;
        fontDir.enable = true;

        fontconfig.defaultFonts = {
          monospace = [
            "JetBrains Mono Nerd Font"
            "JetBrains Mono"
          ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
        };
      };
    })
  ];
}
