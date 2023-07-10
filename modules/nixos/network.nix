{ config
, ...
}: {
  config =
    let
      cfg = config.privateConfig.resolved;
    in
    {
      networking.nameservers = cfg.dns;
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
