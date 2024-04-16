{ config
, ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
    systemConfig.minimal = true;

    nixosConfig.networking.resolved = true;

    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
      fail2ban.enable = true;
    };

    users.users.root.openssh.authorizedKeys.keys = [
      config.privateConfig.ssh.publicKey
    ];

    systemd.network.networks = config.lib.config.mkNetworkCfg {
      "enp0s31f6" = {
        networkConfig.MulticastDNS = "yes";
      };
    };

    services.resolved = {
      extraConfig = ''
        MulticastDNS=true
      '';
    };

  };
}
