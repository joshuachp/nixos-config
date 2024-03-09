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
        && machineCfg.${hostname}.wireguard.server;
    in
    lib.mkIf enable (
      let
        hostCfg = machineCfg.${hostname}.wireguard;
        inherit (hostCfg) port addressIpv4 privateKeyPath range;
        mkPeer = import ./mkPeer.nix lib;
        # Extract only other peers
        peersCfg = lib.filterAttrs (n: v: n != hostname) machineCfg;
        dnsAddresses = lib.mapAttrsToList
          (n: v: "/${n}.wg/${v.wireguard.addressIpv4}")
          machineCfg;
        peers = lib.mapAttrsToList (n: mkPeer) peersCfg;
        ingressIp = "10.2.0.1";
      in
      {
        # DNS instead of /etc/hosts
        services.dnsmasq = {
          enable = true;
          settings = {
            interface = "wg0";
            address = dnsAddresses ++ [
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
              "/kubeapi.k.joshuachp.dev/10.10.10.100"
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
            address = [ "${addressIpv4}/${toString range}" ] ++ hostCfg.peers;
            listenPort = port;
            privateKeyFile = privateKeyPath;
            inherit peers;
          };
        };
      }
    );
}
