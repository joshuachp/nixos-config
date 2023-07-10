{ config
, hostname
, ...
}: {
  config =
    let
      cfg = config.privateConfig.wireguard;
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
        allowedUDPPorts = [ cfg.port ];
      };
      # Wireguard interface
      networking.wg-quick.interfaces.wg0 = {
        autostart = true;
        # IP address subnet at the client end
        address = [ hostConf."${hostname}".address ];
        # Set a split DNS to route only the .wg domains through wireguard
        postUp = ''
          resolvconf -f -d wg0
          resolvectl dns wg0 10.0.0.2 fdc9:281f:04d7:9ee9::2
          resolvectl domain wg0 '~wg'
        '';
        listenPort = cfg.port;
        privateKeyFile = hostConf."${hostname}".key;
        peers = [
          # Nixos Cloud
          {
            publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
            endpoint = "${cfg.serverIp}:${toString cfg.port}";
            allowedIPs = [ "10.0.0.2/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
}
