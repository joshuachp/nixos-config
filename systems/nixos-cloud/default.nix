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
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

      services.openssh = {
        enable = true;
        # Random port
        ports = [ sshPort ];
        settings.PasswordAuthentication = false;
      };

      networking.firewall = {
        enable = true;
        allowedUDPPorts = [ sshPort ];
        allowedTCPPorts = [ sshPort ];
      };

      services.fail2ban.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH04ZDdmAFdHNO3kizLB383BeaZIYuqRnNwFx5uGNhIN openpgp:0x80D62E31"
      ];
    };
}
