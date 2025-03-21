{ config, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
    systemd.network.networks = config.lib.config.mkNetworkCfg {
      "enp1s0" = { };
      "enp7s0" = {
        linkConfig.RequiredForOnline = "no";
      };
    };

    nixosConfig.server.k3s = {
      enable = true;
      role = "main";
      interface = "enp7s0";
      ip = "10.1.0.2";
      externalIp =
        config.lib.config.wireguard.mkServerIpv4
          config.privateConfig.machines.${hostname}.wireguard.id;
    };
  };
}
