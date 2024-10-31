# Desktop packages
{
  config,
  pkgs,
  lib,
}:
let
  cfg = config.systemConfig.desktop;
  mattermost =
    if cfg.wayland then
      config.lib.config.wrapElectronWayland pkgs.mattermost-desktop
    else
      pkgs.mattermost-desktop;
in
(with pkgs; [
  # Terminals
  alacritty

  # Editor
  vscode

  # Browser
  firefox-bin
  chromium

  # Applications
  libreoffice
  rnote # NOTE: Testing as a xournalpp alternative
  spotify
  thunderbird
  vlc
  xournalpp
  zathura

  # Chat apps
  signal-desktop
  element-desktop
  tdesktop

  # CLI tools for desktop
  gnuplot
  libnotify
  playerctl
  xclip
])
++ [ mattermost ]
++ lib.optionals cfg.wayland (with pkgs; [ wl-clipboard ])
