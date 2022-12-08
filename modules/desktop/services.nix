{ config
, pkgs
, ...
}: {
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

    # Printers
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    # Smart-Cards
    services.pcscd.enable = true;
  };
}
