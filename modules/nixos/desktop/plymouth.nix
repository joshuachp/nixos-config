# Enables plymouth with quiet boot configuration
{ config, lib, ... }:
let
  cfg = config.nixosConfig.boot.plymouth;
in
{
  options = {
    nixosConfig.boot.plymouth.enable = lib.mkEnableOption "plymouth boot splash screen" // {
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      # Enable the plymouth service
      plymouth.enable = true;
      # Make the boot quiet (man kernel-command-line), should make the password prompt for the
      # LUCKS device
      kernelParams = [ "quiet" ];
    };
  };
}
