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
        inherit (cfg.wireguard) privateKeyPath port;
        # Function to create peers
        inherit (config.lib.config.wireguard) mkClientPeer mkServerIpv4 mkIpv4Range;
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
        peers = lib.mapAttrsToList (n: mkClientPeer) serverCfg;
      in
      {
        # Open the firewall port
        networking.firewall = {
          trustedInterfaces = [
            "wg0"
          ];
          allowedUDPPorts = [
            port
          ];
        };

        # Wireguard interface
        networking.wg-quick.interfaces.wg0 = {
          listenPort = port;
          privateKeyFile = privateKeyPath;
          inherit address peers;
          postUp = ''
            set -eEuo pipefail

            # DNS resolution
            resolvconf -f -d wg0
            resolvectl dns wg0 ${nameservers}
            resolvectl domain wg0 '~wg' '~${clusterDomain}'
          '';
        };
      }
    );
}
