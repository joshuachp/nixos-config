{ config
, pkgs
, installPkgs
, ...
}: {
  config = {
    services.xserver.windowManager.i3.enable = true;
  } // installPkgs (with pkgs; [
    feh
    polybar
    rofi
  ]);
}
