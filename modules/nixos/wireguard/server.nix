# Wireguard server config
{ config
, lib
, hostname
, ...
}: {
  config =
    let
      machineCfg = config.privateConfig.machines;
      enable = (builtins.hasAttr hostname machineCfg)
        && machineCfg.${hostname}.wireguard.server.enable;
    in
    lib.mkIf enable (
      let
        inherit (machineCfg.${hostname}.wireguard) id privateKeyPath;
        inherit (machineCfg.${hostname}.wireguard.server) port;
        # Function to create the peers
        inherit (config.lib.config.wireguard) mkPeer mkClientAddresses mkServerIpv4 mkClientIpv4;
        # Filter all server config
        allServerCfg = lib.filterAttrs
          (n: v: v.wireguard.server.enable)
          machineCfg;
        # Filter only other servers
        serverCfg = lib.filterAttrs
          (n: v: n != hostname && v.wireguard.server.enable)
          machineCfg;
        # Filter only clients
        clientsCfg = lib.filterAttrs
          (n: v: n != hostname && !v.wireguard.server.enable)
          machineCfg;
        serverDnsAddresses = lib.mapAttrsToList
          (n: v: "/${n}.wg/${mkServerIpv4 v.wireguard.id}")
          allServerCfg;
        mkClientDnsAddress = client: id: servers:
          lib.mapAttrsToList
            (n: v: "/${client}.wg/${mkClientIpv4 v.wireguard.id id}")
            servers;
        clientDnsAddresses = lib.flatten
          (lib.mapAttrsToList
            (n: v: mkClientDnsAddress n v.wireguard.id allServerCfg)
            clientsCfg);
        serverPeers = lib.mapAttrsToList (n: (mkPeer [ ])) serverCfg;
        clientPeers = lib.mapAttrsToList
          (n: v:
            let
              addresses = mkClientAddresses v.wireguard.id allServerCfg;
            in
            mkPeer addresses v)
          clientsCfg;
        ingressIp = "10.2.0.1";
        inherit (config.nixosConfig.server.k3s) loadBalancerIp;
      in
      {
        # DNS instead of /etc/hosts
        services.dnsmasq = {
          enable = true;
          settings = {
            interface = "wg0";
            address = serverDnsAddresses ++ clientDnsAddresses ++ [
              "/alertmanager.k.joshuachp.dev/${ingressIp}"
              "/argocd.k.joshuachp.dev/${ingressIp}"
              "/atuin.k.joshuachp.dev/${ingressIp}"
              "/ci.k.joshuachp.dev/${ingressIp}"
              "/firefly.k.joshuachp.dev/${ingressIp}"
              "/git.k.joshuachp.dev/${ingressIp}"
              "/grafana.k.joshuachp.dev/${ingressIp}"
              "/home.k.joshuachp.dev/${ingressIp}"
              "/importer.k.joshuachp.dev/${ingressIp}"
              "/kubernetes-dashboard.k.joshuachp.dev/${ingressIp}"
              "/ntfy.k.joshuachp.dev/${ingressIp}"
              "/pg.k.joshuachp.dev/${ingressIp}"
              "/prometheus.k.joshuachp.dev/${ingressIp}"
              "/syncthing.k.joshuachp.dev/${ingressIp}"
              "/traefik.k.joshuachp.dev/${ingressIp}"
              # HA proxy IP
              "/kubeapi.k.joshuachp.dev/${loadBalancerIp}"
            ];
          };
        };
        # Used for wireguard VPN DNS
        nixosConfig = {
          networking = {
            resolved = lib.mkDefault false;
            dnsmasq = lib.mkDefault true;
            privateDns = lib.mkDefault true;
          };
        };

        networking = {
          # Open the firewall port
          firewall = {
            allowedUDPPorts = [ port ];
            trustedInterfaces = [ "wg0" ];
          };

          # Enable NAT
          nat = {
            enable = true;
            enableIPv6 = true;
            internalInterfaces = [ "wg0" ];
          };

          # Wireguard interface
          wg-quick.interfaces.wg0 = {
            # Clients IP address subnet
            address = [ "${mkServerIpv4 id}/24" ];
            listenPort = port;
            privateKeyFile = privateKeyPath;
            peers = serverPeers ++ clientPeers;
          };
        };
      }
    );
}
