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
      boot.loader.grub.device = "/dev/sda";
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

      systemConfig.minimal = true;

      networking.firewall.enable = true;

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

      nixosConfig.server.k3s.enable = true;
      services.k3s.serverAddr = "https://10.0.1.1:6443";
    };
}
