{ config
, lib
, hostname
, ...
}: {
  config =
    let
      machineCfg = config.privateConfig.machines;
      enable = (builtins.hasAttr hostname machineCfg)
        && (!machineCfg.${hostname}.wireguard.server);
    in
    lib.mkIf enable (
      let
        hostCfg = machineCfg.${hostname}.wireguard;
        # Function to create peers
        inherit (config.lib.config.wireguard) mkClientPeer;
        # k3s cluster for custom Domains
        clusterDomain = config.privateConfig.k3s.domain;
        # Wg options
        inherit (hostCfg) port addressIpv4 privateKeyPath range;
        # Filter only servers
        serverCfg = lib.filterAttrs
          (n: v: n != hostname && v.wireguard.server)
          machineCfg;
        # dnsmasq wg addresses
        nameservers = builtins.concatStringsSep " " (
          lib.mapAttrsToList (n: v: v.wireguard.addressIpv4) serverCfg
        );
        peers = lib.mapAttrsToList (n: mkClientPeer) serverCfg;
      in
      {
        # Open the firewall port
        networking.firewall = {
          allowedUDPPorts = [ port ];
          trustedInterfaces = [ "wg0" ];
        };

        # Wireguard interface
        networking.wg-quick.interfaces.wg0 = {
          autostart = true;
          # IP address subnet at the client end
          address = [ "${addressIpv4}/${toString range}" ];
          # Set a split DNS to route only the .wg domains through wireguard
          postUp = ''
            resolvconf -f -d wg0
            resolvectl dns wg0 ${nameservers}
            resolvectl domain wg0 '~wg' '~${clusterDomain}'
          '';
          listenPort = port;
          privateKeyFile = privateKeyPath;
          inherit peers;
        };
      }
    );
}
