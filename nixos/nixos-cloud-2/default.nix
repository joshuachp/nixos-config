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

      nixosConfig = {
        networking.enable = true;
        wireguard.client = true;
      };

      services.openssh = {
        enable = true;
        # Opened through wireguard
        openFirewall = false;
        # Random port
        ports = [ sshPort ];
        settings.PasswordAuthentication = false;
      };

      networking.firewall.enable = true;

      services.fail2ban.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        config.privateConfig.ssh.publicKey
      ];
    };
}
