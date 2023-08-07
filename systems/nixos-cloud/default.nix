{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    # Modules
    ../../modules/nixos/localization.nix
    ../../modules/nixos/localtime.nix
    ../../modules/nixos/nix
    ../../modules/nixos/wireguard/server.nix
  ];
  config =
    let
      sshPort = config.deploy.port;
    in
    {
      boot.loader.grub.device = "/dev/sda";
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

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
