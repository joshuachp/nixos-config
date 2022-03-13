{pkgs, ...}: {
  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };
}
