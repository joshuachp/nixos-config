{ config, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
    boot.kernelParams = [
      "panic=10"
    ];

    systemConfig.minimal = true;

    nixosConfig.networking.resolved = true;

    privateConfig.remote-builder.enable = true;

    services = {
      openssh = {
        openFirewall = true;
      };
      fail2ban.enable = true;
    };

    systemd.network.networks = config.lib.config.mkNetworkCfg {
      "enp1s0" = {
        networkConfig.MulticastDNS = "yes";
        routes = [
          {
            Destination = "192.168.3.0/24";
          }
        ];
      };
      "wlp2s0" = {
        networkConfig.MulticastDNS = "yes";
      };
    };
    networking.firewall.allowedUDPPorts = [ 5353 ];

    # Pi-hole local
    networking.firewall.extraInputRules = "
      ip saddr 192.168.1.0/24 tcp dport 53 accept
      ip saddr 192.168.1.0/24 udp dport { 53, 67 } accept
    ";

    services.resolved = {
      extraConfig = ''
        MulticastDNS=true
      '';
    };

    services = {
      fwupd.enable = true;
      thermald.enable = true;
    };

    # Never suspend
    services.logind.lidSwitch = "ignore";

    nixosConfig.server.k3s = {
      enable = true;
      role = "agent";
      interface = "wg0";
      ip = "10.0.0.8";
      externalIp =
        config.lib.config.wireguard.mkServerIpv4
          config.privateConfig.machines.${hostname}.wireguard.id;
    };
  };
}
