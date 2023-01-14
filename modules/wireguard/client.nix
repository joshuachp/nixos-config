{ config
, hostname
, ...
}: {
  config =
    let
      wireguardHost = config.privateConfig.wireguard.serverIp;
      port = 43978;
      privateKeys = {
        nixos = config.sops.secrets.wireguard_nixos_private.path;
        nixos-cloud = config.sops.secrets.wireguard_nixos_cloud_private.path;
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
        address = [ "10.0.0.1/24" ];
        listenPort = port;
        privateKeyFile = privateKeys."${hostname}";
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
