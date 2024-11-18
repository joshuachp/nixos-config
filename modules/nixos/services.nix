# Configures default system services
_: {
  config = {
    # use shellcheck for systemd services
    # systemd.enableStrictShellChecks = true;
    # Setup journald vacuum to keep logs for 1 week.
    services.journald.extraConfig = ''
      MaxRetentionSec=1week
    '';
  };
}
