{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.systemConfig.desktop;
in
{
  config = lib.mkIf cfg.enable {
    # Printers
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
  };
}
