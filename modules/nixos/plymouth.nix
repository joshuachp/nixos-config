# Enables plymouth with quiet boot configuration
{ config
, lib
, ...
}:
let
  cfg = config.nixosConfig.boot.plymouth;
in
{
  options = {
    nixosConfig.boot.plymouth.enable = lib.options.mkOption {
      default = false;
      defaultText = "Enable plymouth boot splash screen";
      description = ''
        Make the plymouth boot splash screen available with the kernel parameters configuration for
        silent boot.
      '';
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable the plymouth service
    boot.plymouth.enable = true;
    # Make the boot quiet (man kernel-command-line), should make the password prompt for the
    # LUCKS device
    boot.kernelParams = [ "quiet" ];

    # NOTE: This could be buggy and some of the initrd.systemd options are unstable and subject to
    #       change, but it's needed to start plymouth in stage 1
    boot.initrd.systemd.enable = true;
  };
}
