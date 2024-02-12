{ config
, lib
, ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
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
      nixosConfig = {
        networking = {
          resolved = false;
          dnsmasq = true;
          # Used for wireguard VPN DNS
          privateDns = true;
        };
        wireguard.server = true;
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

        dnsmasq.settings = {
          address =
            let
              clusterIp = config.nixosConfig.wireguard.hostConfig.nixos-cloud-2.addressIpv4;
            in
            [
              "/git.k.joshuachp.dev/${clusterIp}"
              "/home.k.joshuachp.dev/${clusterIp}"
              "/kubernetes-dashboard.k.joshuachp.dev/${clusterIp}"
              "/ntfy.k.joshuachp.dev/${clusterIp}"
              "/syncthing.k.joshuachp.dev/${clusterIp}"
              "/traefik.k.joshuachp.dev/${clusterIp}"
            ];
        };
      };

      users.users.root.openssh.authorizedKeys.keys = [
        config.privateConfig.ssh.publicKey
      ];
    };
}
