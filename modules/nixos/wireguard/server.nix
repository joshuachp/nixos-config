{ config
, hostname
, ...
}: {
  config =
    let
      privateKeys = {
        nixos = config.sops.secrets.wireguard_nixos_private.path;
        nixos-cloud = config.sops.secrets.wireguard_nixos_cloud_private.path;
        nixos-work = config.sops.secrets.wireguard_nixos_work_private.path;
      };
      wireguardPort = config.privateConfig.wireguard.port;
      inherit (config) privateConfig;
    in
    {
      # DNS instead of /etc/hosts
      services.dnsmasq = {
        enable = true;
        settings = {
          interface = "wg0";
          address = [
            "/${privateConfig.nixos-cloud.address}/10.0.0.2"
            "/nixos.wg/10.0.0.1"
            "/nixos-cloud.wg/10.0.0.2"
            # "/nixos-work.wg/10.0.0.3"
            "/nord.wg/10.0.0.4"
          ];
        };
      };

      networking = {
        # Open the firewall port
        firewall = {
          allowedUDPPorts = [ wireguardPort ];
          trustedInterfaces = [ "wg0" ];
        };

        # Enable NAT
        nat = {
          enable = true;
          enableIPv6 = true;
          internalInterfaces = [ "wg0" ];
        };

        # Wireguard interface
        wg-quick.interfaces.wg0 = {
          # Clients IP address subnet
          address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
          listenPort = wireguardPort;
          privateKeyFile = privateKeys."${hostname}";
          peers = [
            # Nixos
            {
              publicKey = privateConfig.wireguard.nixosPublicKey;
              allowedIPs = [ "10.0.0.1/32" "fdc9:281f:04d7:9ee9::1/128" ];
            }
            # Nixos Cloud
            # {
            #   publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
            #   allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
            # }
            # Nixos Work
            {
              publicKey = privateConfig.wireguard.nixosWorkPublicKey;
              allowedIPs = [ "10.0.0.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
            }
            # Nord
            {
              publicKey = privateConfig.wireguard.androidPublicKey;
              allowedIPs = [ "10.0.0.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
            }
          ];
        };
      };
    };
}
