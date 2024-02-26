# DNS config
{ config
, lib
, ...
}:
{
  options = {
    nixosConfig.networking = {
      resolved = lib.mkEnableOption "Systemd resolve" // {
        # Enable on desktop
        default = config.systemConfig.desktop.enable;
      };
      dnsmasq = lib.mkEnableOption "Dns masq";
      privateDns = lib.mkEnableOption "private DNS resolver";
      mDNS = lib.mkEnableOption "enable mDNS resolver" // {
        default = config.systemConfig.desktop.enable;
      };
    };
  };
  config =
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
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = !(cfg.resolved && cfg.dnsmasq);
            message = "Enable either resolved or dnsmasq not both";
          }
        ];
      }
      # systemd-resolved config
      (lib.mkIf cfg.resolved (
        let
          dns =
            if cfg.privateDns then
              privateCfg.resolved.dns
            else
              fallbackDns;
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
      # dnsmasq config
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
          # This has higher priority than mkDefault but not of a option
          services.resolved.enable = lib.mkOverride 900 false;
        }
      ))
      # MDNS
      (lib.mkIf cfg.mDNS {
        services.avahi = {
          enable = true;
          nssmdns4 = true;
        };
      })
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
