{ config, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
    systemConfig.minimal = true;

    nixosConfig.networking.resolved = true;

    privateConfig.remote-builder.enable = true;

    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
      fail2ban.enable = true;
    };

    users.users.root.openssh.authorizedKeys.keys = [ config.privateConfig.ssh.publicKey ];

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
