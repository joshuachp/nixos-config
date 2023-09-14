# Configures default system services
_: {
  config = {
    # Setup journald vacuum to keep logs for 1 week.
    services.journald.extraConfig = ''
      MaxRetentionSec=1week
    '';
  };
}
