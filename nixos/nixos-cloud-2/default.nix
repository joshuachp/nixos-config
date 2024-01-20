{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config =
    let
      sshPort = config.deploy.port;
    in
    {
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

      systemConfig.minimal = true;
      nixosConfig = {
        networking.enable = true;
        wireguard.client = true;
      };

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
    };
}
