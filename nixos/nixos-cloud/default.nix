{ config
, ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  config =
    let
      sshPort = config.privateConfig.deploy.nixos-cloud.port;
    in
    {
      zramSwap.enable = true;

      systemConfig.minimal = true;

      services = {
        openssh = {
          enable = true;
          # Opened through wireguard
          openFirewall = false;
          # Random port
          ports = [ sshPort ];
          settings.PasswordAuthentication = false;
        };
        fail2ban.enable = true;
      };

      users.users.root.openssh.authorizedKeys.keys = [
        config.privateConfig.ssh.publicKey
      ];

      systemd.network.networks = {
        "11-enp1s0" = {
          matchConfig.Name = "enp1s0";
          networkConfig.DHCP = "yes";
        };
        "17-enp7s0" = {
          matchConfig.Name = "enp7s0";
          networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
        };
      };

      nixosConfig.server.k3s = {
        enable = true;
        interface = "enp7s0";
        ip = "10.1.0.3";
      };
    };
}
