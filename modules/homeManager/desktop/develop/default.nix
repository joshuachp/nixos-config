{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
{
  imports = [
    ./git.nix
    ./jj.nix
  ];
  options = {
    homeConfig = {
      docker.enable = lib.mkEnableOption "docker config" // {
        default = osConfig.nixosConfig.develop.docker.enable or true;
      };
    };
  };

  config =
    let
      cfg = config.homeConfig.docker;
    in
    lib.mkIf cfg.enable {
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
