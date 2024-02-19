{ config
, lib
, pkgs
, ...
}:
{
  options = {
    homeConfig.docker.config = lib.mkEnableOption "docker config";
  };
  config =
    let
      cfg = config.homeConfig.docker;
      enable = config.systemConfig.desktop.enable && cfg.config;
    in
    lib.mkIf enable {
      home.packages = with pkgs; [
        docker-credential-helpers
      ];
      home.file.".docker/config.json".text = builtins.toJSON {
        credsStore = "secretservice";
        # This needs manual configuration for the firs `docker login`
        auths = {
          "https://index.docker.io/v1/" = { };
        };
      };
    };
}
