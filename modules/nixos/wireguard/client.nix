{ config
, hostname
, ...
}: {
  config =
    let
      wireguardHost = config.privateConfig.wireguard.serverIp;
      port = 43978;
      hostConf = {
        nixos = {
          key = config.sops.secrets.wireguard_nixos_private.path;
          address = "10.0.0.1/24";
        };
        nixos-cloud = {
          key = config.sops.secrets.wireguard_nixos_cloud_private.path;
          address = "10.0.0.2/24";
        };
        nixos-work = {
          key = config.sops.secrets.wireguard_nixos_work_private.path;
          address = "10.0.0.3/24";
        };
      };
    in
    {
      # Open the firewall port
      networking.firewall = {
        allowedUDPPorts = [ port ];
      };
      # Wireguard interface
      networking.wg-quick.interfaces.wg0 = {
        # IP address subnet at the client end
        address = [ hostConf."${hostname}".address ];
        dns = [ "10.0.0.2" "fdc9:281f:04d7:9ee9::2" ];
        listenPort = port;
        privateKeyFile = hostConf."${hostname}".key;
        peers = [
          # Nixos Cloud
          {
            publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
            endpoint = "${wireguardHost}:${toString port}";
            allowedIPs = [ "10.0.0.2/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
}