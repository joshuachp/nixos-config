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

    boot.loader.systemd-boot.memtest86.enable = true;

    nixosConfig.networking.resolved = true;

    privateConfig.remoteBuilder.enable = true;

    # limit the resources used
    nix.settings = {
      max-jobs = 2;
      cores = 4;
    };

    services = {
      earlyoom.enable = true;

      openssh = {
        openFirewall = true;
      };
      fail2ban.enable = true;
    };

    systemd.network.networks = config.lib.config.mkNetworkCfg {
      "enp0s31f6" = {
        networkConfig.MulticastDNS = "yes";
      };
    };
    networking.firewall.allowedUDPPorts = [ 5353 ];

    services.resolved = {
      extraConfig = ''
        MulticastDNS=true
      '';
    };

    security.tpm2.enable = true;
    services = {
      fwupd.enable = true;
      thermald.enable = true;
    };

    nixosConfig.server.k3s = {
      enable = true;
      role = "agent";
      interface = "wg0";
      ip = "10.0.0.4";
      externalIp =
        config.lib.config.wireguard.mkServerIpv4
          config.privateConfig.machines.${hostname}.wireguard.id;
    };
  };
}
