{ config
, lib
, hostname
, ...
}: {
  config =
    let
      machineCfg = config.privateConfig.machines;
      enable = (builtins.hasAttr hostname machineCfg)
        && (!machineCfg.${hostname}.wireguard.server.enable);
    in
    lib.mkIf enable (
      let
        # k3s cluster for custom Domains
        clusterDomain = config.privateConfig.k3s.domain;
        # Wg options
        cfg = machineCfg.${hostname};
        inherit (machineCfg.${hostname}.wireguard) privateKeyPath;
        # Function to create peers
        inherit (config.lib.config.wireguard) mkClientPeer mkCidr mkServerIpv4 mkIpv4Range mkRoutes mkInterfaceName;
        # Filter only servers
        serverCfg = lib.filterAttrs
          (n: v: n != hostname && v.wireguard.server.enable)
          machineCfg;
        # DNS name servers
        nameservers = builtins.concatStringsSep " "
          (lib.mapAttrsToList
            (n: v: mkServerIpv4 v.wireguard.id)
            serverCfg);
        # Client addresses
        address = [ (mkIpv4Range cfg) ];
        # Function to create an interface for a server
        mkInterface = server:
          let
            itf = mkInterfaceName server.wireguard.id;
            serverCdir = mkCidr server;
            peerRoutes = mkRoutes server;
            serverIp = mkServerIpv4 server.wireguard.id;
          in
          {
            name = itf;
            value = {
              autostart = true;
              inherit address;
              table = "off";
              postUp = ''
                set -eEuo pipefail
                ip -4 route add ${serverCdir} dev ${itf}
                # Client cdir
                ip route append 10.0.0.0/24 scope global nexthop dev ${itf} via ${serverIp} weight 1
              ''
              + peerRoutes
              + ''
                resolvconf -f -d ${itf}
                resolvectl dns ${itf} ${nameservers}
                resolvectl domain ${itf} '~wg' '~${clusterDomain}'
              '';
              privateKeyFile = privateKeyPath;
              peers = [
                (mkClientPeer server)
              ];
            };
          };
        # Interfaces names
        interfaceNames = lib.mapAttrsToList (n: v: mkInterfaceName v.wireguard.id) serverCfg;
        # Interface values
        interfaces = lib.mapAttrs' (n: mkInterface) serverCfg;
      in
      {
        # Open the firewall port
        networking.firewall = {
          trustedInterfaces = interfaceNames;
        };

        # Wireguard interface
        networking.wg-quick = { inherit interfaces; };
      }
    );
}
