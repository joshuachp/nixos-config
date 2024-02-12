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
      privateConfig.k3s.secret = true;
      services.k3s = {
        enable = true;
        tokenFile = config.sops.secrets.k3s_token.path;
        extraFlags = builtins.concatStringsSep " " [
          "--secrets-encryption"
          "--disable=traefik"
        ];
      };
    };
}
