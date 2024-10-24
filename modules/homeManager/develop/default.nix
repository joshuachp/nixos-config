{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./jj.nix
  ];
  options = {
    homeConfig = {
      docker.config = lib.mkEnableOption "docker config";
    };
  };
  config =
    let
      cfgDocker = config.homeConfig.docker;
      enableDocker = config.systemConfig.desktop.enable && cfgDocker.config;
    in
    lib.mkIf enableDocker {
      home.packages = with pkgs; [ docker-credential-helpers ];
      home.file.".docker/config.json".text = builtins.toJSON {
        credsStore = "secretservice";
        # This needs manual configuration for the firs `docker login`
        auths = {
          "https://index.docker.io/v1/" = { };
        };
      };
    };
}
