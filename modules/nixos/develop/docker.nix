# Enable Docker
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nixosConfig.develop.docker = lib.mkEnableOption "docker tools" // {
      default = true;
    };
  };
  config =
    let
      cfg = config.nixosConfig.develop;
    in
    lib.mkIf (cfg.enable && cfg.docker) {
      # Enable docker
      virtualisation.docker = {
        enable = true;
        # Only for dev, no need to start on boot
        enableOnBoot = false;
        # Prune
        autoPrune.enable = true;
      };
      environment.systemPackages = with pkgs; [ lazydocker ];
      users.users.joshuachp.extraGroups = [ "docker" ];
    };
}
