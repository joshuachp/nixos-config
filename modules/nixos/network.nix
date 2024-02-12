# Setup networking like DNS
{ config
, lib
, ...
}:
let
  cfg = config.nixosConfig.networking;
  privateCfg = config.privateConfig;
  fallbackDns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
in
{
  options = {
    nixosConfig.networking = {
      resolved = lib.mkEnableOption "Systemd resolve" // { default = true; };
      dnsmasq = lib.mkEnableOption "Dns masq";
      privateDns = lib.mkEnableOption "private DNS resolver";
    };
  };
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.resolved && cfg.dnsmasq);
          message = "Enable either resolved or dnsmasq not both";
        }
      ];
    }
    (lib.mkIf cfg.resolved (
      let
        dns =
          if cfg.privateDns then
            privateCfg.resolved.dns
          else fallbackDns;
      in
      {
        services.resolved = {
          enable = true;
          fallbackDns = dns;
          dnssec = "false";
          extraConfig = ''
            DNSOverTLS=opportunistic
          '';
        };
        networking.nameservers = dns;
        networking.networkmanager.dns = "systemd-resolved";
      }
    ))
    (lib.mkIf cfg.dnsmasq (
      let
        dns =
          if cfg.privateDns then
            privateCfg.dnsmasq.server
          else
            fallbackDns;
      in
      {
        services.dnsmasq = {
          enable = true;
          settings = {
            server = dns;
            add-cpe-id = lib.mkIf cfg.privateDns privateCfg.dnsmasq.add-cpe-id;
          };
        };
        networking.nameservers = dns;
        networking.networkmanager.dns = "dnsmasq";
      }
    ))
    # Disable mDNS if Avahi is enable
    (lib.mkIf config.services.avahi.enable {
      services.resolved = {
        llmnr = "false";
        extraConfig = ''
          MulticastDNS=false
        '';
      };
    })
  ];
}
