# Development config
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.nixosConfig.develop;
in
{
  options = {
    nixosConfig.develop.enable = lib.mkEnableOption "develop environment";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = import ../../../pkgs/develop { inherit pkgs; };

    # Enable direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
