{ config
, lib
, hostname
, ...
}: {
  config =
    let
      privateCfg = config.privateConfig.wireguard;
      cfg = config.nixosConfig.wireguard;
      routerIpv4 = cfg.hostConfig.nixos-cloud.addressIpv4;
      routerIpv6 = cfg.hostConfig.nixos-cloud.addressIpv6;
    in
    lib.mkIf cfg.client {
      # Open the firewall port
      networking.firewall = {
        allowedUDPPorts = [ privateCfg.port ];
        trustedInterfaces = [ "wg0" ];
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
            resolvectl dns wg0 ${routerIpv4} ${routerIpv6}
            resolvectl domain wg0 '~wg' '~k.joshuachp.dev'
          '';
          listenPort = privateCfg.port;
          privateKeyFile = privateKey;
          peers = [
            # Nixos Cloud
            {
              publicKey = config.privateConfig.wireguard.nixosCloudPublicKey;
              endpoint = "${privateCfg.serverIp}:${toString privateCfg.port}";
              allowedIPs = [ "${routerIpv4}/24" "${routerIpv6}/64" ];
              persistentKeepalive = 25;
            }
          ];
        };
    };
}
