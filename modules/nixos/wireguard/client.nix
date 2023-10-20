{ config
, lib
, hostname
, ...
}: {
  config =
    let
      privateCfg = config.privateConfig.wireguard;
      cfg = config.nixosConfig.wireguard;
    in
    lib.mkIf cfg.client {
      # Open the firewall port
      networking.firewall = {
        allowedUDPPorts = [ privateCfg.port ];
      };
      # Wireguard interface
      networking.wg-quick.interfaces.wg0 =
        let
          inherit (cfg.hostConfig.${hostname}) privateKey addressIpv4;
        in
        {
          autostart = true;
          # IP address subnet at the client end
          address = [ "${addressIpv4}/24" ];
          # Set a split DNS to route only the .wg domains through wireguard
          postUp = ''
            resolvconf -f -d wg0
            resolvectl dns wg0 10.0.0.2 fdc9:281f:04d7:9ee9::2
            resolvectl domain wg0 '~wg'
          '';
          listenPort = privateCfg.port;
          privateKeyFile = privateKey;
          peers = [
            # Nixos Cloud
            {
              publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
              endpoint = "${privateCfg.serverIp}:${toString privateCfg.port}";
              allowedIPs = [ "10.0.0.2/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
    };
}
