{ pkgs
, ...
}: {
  config = {
    # Printers
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
  };
}
