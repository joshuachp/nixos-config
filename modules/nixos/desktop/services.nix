{ pkgs
, ...
}: {
  config = {
    # Printers
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    # Smart-Cards
    services.pcscd.enable = true;
  };
}
