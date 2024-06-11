# Desktop audio configuration
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
  config = lib.mkIf cfg.enable {
    # Sound
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      pavucontrol
      easyeffects
    ];
  };
}
