{ config
, hostname
, ...
}: {
  config =
    let
      port = 51820;
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

      # Enable NAT
      networking.nat = {
        enable = true;
        enableIPv6 = true;
        internalInterfaces = [ "wg0" ];
      };

      # Wireguard interface
      networking.wg-quick.interfaces.wg0 = {
        address = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
        listenPort = port;
        privateKeyFile = privateKeys."${hostname}";
        peers = [
          # Nixos
          {
            publicKey = config.privateConfig.wireguard.nixosPublicKey;
            allowedIPs = [ "10.0.0.1/32" "fdc9:281f:04d7:9ee9::2/128" ];
            persistentKeepalive = 25;
          }
          # Nixos Cloud
          {
            publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
            allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
}
