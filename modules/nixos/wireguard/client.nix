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
        inherit (machineCfg.${hostname}.wireguard) id privateKeyPath;
        # Function to create peers
        inherit (config.lib.config.wireguard) mkClientPeer mkServerIpv4 mkClientAddresses;
        # Filter only servers
        serverCfg = lib.filterAttrs
          (n: v: n != hostname && v.wireguard.server.enable)
          machineCfg;
        # dnsmasq wg addresses
        nameservers = builtins.concatStringsSep " "
          (lib.mapAttrsToList
            (n: v: mkServerIpv4 v.wireguard.id)
            serverCfg);
        address = mkClientAddresses id serverCfg;
        peers = lib.mapAttrsToList (n: mkClientPeer) serverCfg;
      in
      {
        # Open the firewall port
        networking.firewall = {
          trustedInterfaces = [ "wg0" ];
        };

        # Wireguard interface
        networking.wg-quick.interfaces.wg0 = {
          autostart = true;
          inherit address;
          postUp = ''
            resolvconf -f -d wg0
            resolvectl dns wg0 ${nameservers}
            resolvectl domain wg0 '~wg' '~${clusterDomain}'
          '';
          privateKeyFile = privateKeyPath;
          inherit peers;
        };
      }
    );
}
