{pkgs, ...}: {
  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  # Printers
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  # Smart-Cards
  services.pcscd.enable = true;
}
