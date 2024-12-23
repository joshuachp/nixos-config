{ config, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
    zramSwap.enable = true;

    services = {
      openssh = {
        enable = true;
        # Opened through wireguard
        openFirewall = false;
        settings.PasswordAuthentication = false;
      };
      fail2ban.enable = true;
    };

    users.users.root.openssh.authorizedKeys.keys = [ config.privateConfig.ssh.publicKey ];

    systemd.network.networks = config.lib.config.mkNetworkCfg {
      "enp1s0" = { };
      "enp7s0" = {
        linkConfig.RequiredForOnline = "no";
      };
    };

    nixosConfig.server.k3s = {
      enable = true;
      role = "server";
      interface = "enp7s0";
      ip = "10.1.0.4";
      externalIp =
        config.lib.config.wireguard.mkServerIpv4
          config.privateConfig.machines.${hostname}.wireguard.id;
    };
  };
}
