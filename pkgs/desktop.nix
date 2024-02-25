# Desktop packages
{ config
, pkgs
, lib
}:
let cfg = config.systemConfig.desktop; in
with pkgs; [
  # Terminals
  alacritty

  # Editor
  vscode

  # Browser
  firefox
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
  mattermost-desktop
  signal-desktop
  element-desktop
  tdesktop

  # CLI tools for desktop
  gnuplot
  libnotify
  playerctl
  pulseaudioMicStateOverlay
  xclip

] ++ lib.optionals cfg.wayland (with pkgs;[
  wl-clipboard
])
