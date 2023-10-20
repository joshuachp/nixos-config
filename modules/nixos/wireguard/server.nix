# Wireguard server config
{ config
, lib
, hostname
, ...
}: {
  config =
    let
      cfg = config.nixosConfig.wireguard;
      hostCfg = cfg.hostConfig.${hostname};
      peersCfg = lib.filterAttrs (n: v: n != hostname) cfg.hostConfig;
      privateCfg = config.privateConfig.wireguard;
      dnsAddresses = lib.mapAttrsToList (n: v: "/${n}.wg/${v.addressIpv4}") cfg.hostConfig;
      wgPeers = lib.mapAttrsToList
        (n: v: {
          inherit (v) publicKey;
          allowedIPs = [
            v.addressIpv4
            v.addressIpv6
          ];
        })
        peersCfg;
    in
    lib.mkIf cfg.server {
      # DNS instead of /etc/hosts
      services.dnsmasq = {
        enable = true;
        settings = {
          interface = "wg0";
          address = dnsAddresses;
        };
      };

      networking = {
        # Open the firewall port
        firewall = {
          allowedUDPPorts = [ privateCfg.port ];
          trustedInterfaces = [ "wg0" ];
        };

        # Enable NAT
        nat = {
          enable = true;
          enableIPv6 = true;
          internalInterfaces = [ "wg0" ];
        };

        # Wireguard interface
        wg-quick.interfaces.wg0 = {
          # Clients IP address subnet
          address = [ "${hostCfg.addressIpv4}/24" "${hostCfg.addressIpv6}/64" ];
          listenPort = privateCfg.port;
          privateKeyFile = hostCfg.privateKey;
          peers = wgPeers;
        };
      };
    };
}
