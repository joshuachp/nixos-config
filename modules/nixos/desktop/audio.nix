{ pkgs
, ...
}: {

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    easyeffects
  ];
}
