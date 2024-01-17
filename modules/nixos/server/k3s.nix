{ config
, lib
, ...
}:
{
  options = {
    nixosConfig.server.k3s.enable = lib.mkEnableOption "Enables k3s service";
  };
  config =
    let
      cfg = config.nixosConfig.server.k3s;
    in
    lib.mkIf cfg.enable {
      services. k3s = {
        enable = true;
        extraFlags = builtins.concatStringsSep " " [
          "--secrets-encryption"
          "--disable=traefik"
        ];
      };
    };
}
