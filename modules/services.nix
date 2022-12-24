# Configures default system services
{ config, ... }: {
  config = {
    # Setup journald vacuum to keep logs for 1 week.
    services.journald.extraConfig = ''
      MaxRetentionSec=1week
    '';
  };
}
