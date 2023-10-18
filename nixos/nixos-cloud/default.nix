{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];
  config =
    let
      sshPort = config.deploy.port;
    in
    {
      boot.loader.grub.device = "/dev/sda";
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

      nixosConfig.wireguard.server = true;

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
