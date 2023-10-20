# Setup networking like DNS
{ config
, lib
, ...
}:
let
  cfg = config.nixosConfig.networking;
  privateCfg = config.privateConfig.resolved;

  dns =
    if cfg.privateDns then
      privateCfg.dns
    else [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
in
{
  options = {
    nixosConfig.networking.enable = lib.mkEnableOption "Network configuration";
    nixosConfig.networking.privateDns = lib.mkEnableOption "private DNS resolver";
  };
  config = lib.mkMerge [
    {
      # Enable the networking configuration by default
      nixosConfig.networking.enable = lib.mkDefault true;
    }
    (lib.mkIf cfg.enable {
      networking.nameservers = dns;
      services.resolved = {
        enable = true;
        fallbackDns = dns;
        dnssec = "false";
        extraConfig = ''
          DNSOverTLS=opportunistic
        '';
      };

      networking.networkmanager.dns = "systemd-resolved";
    })
  ];
}
