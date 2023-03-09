{ config
, hostname
, ...
}: {
  config =
    let
      port = 43978;
      privateKeys = {
        nixos = config.sops.secrets.wireguard_nixos_private.path;
        nixos-cloud = config.sops.secrets.wireguard_nixos_cloud_private.path;
        nixos-work = config.sops.secrets.wireguard_nixos_work_private.path;
      };
    in
    {
      # Open the firewall port
      networking.firewall = {
        allowedUDPPorts = [ port ];
        trustedInterfaces = [ "wg0" ];
      };

      # DNS instead of /etc/hosts
      services.dnsmasq = {
        enable = true;
        extraConfig = ''
          interface=wg0
          address=/${config.privateConfig.nixos-cloud.address}/10.0.0.2
        '';
      };

      # Enable NAT
      networking.nat = {
        enable = true;
        enableIPv6 = true;
        internalInterfaces = [ "wg0" ];
      };

      # Wireguard interface
      networking.wg-quick.interfaces.wg0 = {
        # Clients IP address subnet
        address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
        listenPort = port;
        privateKeyFile = privateKeys."${hostname}";
        peers = [
          # Nixos
          {
            publicKey = config.privateConfig.wireguard.nixosPublicKey;
            allowedIPs = [ "10.0.0.1/32" "fdc9:281f:04d7:9ee9::1/128" ];
          }
          # Nixos Cloud
          # {
          #   publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
          #   allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          # }
          # Nixos Work
          {
            publicKey = config.privateConfig.wireguard.nixosWorkPublicKey;
            allowedIPs = [ "10.0.0.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
          }
          # Nixos Work
          {
            publicKey = config.privateConfig.wireguard.androidPublicKey;
            allowedIPs = [ "10.0.0.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
          }
        ];
      };
    };
}
