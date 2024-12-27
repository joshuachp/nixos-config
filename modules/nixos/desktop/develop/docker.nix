# Enable Docker
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nixosConfig.develop.docker.enable = lib.mkEnableOption "docker tools" // {
      default = config.systemConfig.develop.enable;
    };
  };
  config =
    let
      cfg = config.nixosConfig.develop.docker;
    in
    lib.mkIf cfg.enable {
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
