# Desktop audio configuration
{
  pkgs,
  ...
}:
{
  config = {
    # Sound
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # use pipewire instead of pulse
    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      pavucontrol
      easyeffects
    ];
  };
}
