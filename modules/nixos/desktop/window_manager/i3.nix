{ config
, pkgs
, ...
}: {
  config = {
    services.xserver.windowManager.i3.enable = true;


    environment.systemPackages = with pkgs; [
      feh
      polybar
      rofi
    ];
  };
}
