{ config
, hostname
, ...
}: {
  config =
    let
      wireguardHost = config.privateConfig.wireguard.serverIp;
      port = 51820;
      privateKeys = {
        nixos = config.sops.secrets.wireguard_nixos_private.path;
        nixos-cloud = config.sops.secrets.wireguard_nixos_cloud_private.path;
      };
    in
    {
      # Wireguard interface
      networking.wg-quick.interfaces.wg0 = {
        address = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
        listenPort = port;
        privateKeyFile = privateKeys."${hostname}";
        peers = [
          # Nixos Cloud
          {
            publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
            allowedIPs = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
            endpoint = "${wireguardHost}:${toString port}";
            persistentKeepalive = 25;
          }
        ];
      };
    };
}
