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

      systemd.network.networks = config.lib.config.mkNetworkCfg {
        "enp1s0" = { };
        "enp7s0" = { linkConfig.RequiredForOnline = "no"; };
      };

      nixosConfig.server.k3s = {
        enable = true;
        role = "main";
        interface = "enp7s0";
        ip = "10.1.0.2";
      };
    };
}
