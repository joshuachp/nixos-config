{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config =
    let
      sshPort = config.privateConfig.deploy.nixos-cloud-2.port;
    in
    {
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

      nixosConfig.server.k3s = {
        enable = true;
        main = true;
        interface = "enp7s0";
      };
    };
}
