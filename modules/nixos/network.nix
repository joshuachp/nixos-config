{ config
, ...
}: {
  config =
    let
      cfg = config.privateConfig.resolved;
    in
    {
      services.resolved = {
        enable = true;
        fallbackDns = cfg.dns;
        dnssec = "false";
        extraConfig = ''
          DNSOverTLS=opportunistic
        '';
      };

      networking.networkmanager.dns = "systemd-resolved";
    };
}
