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
        clusterIp = machineCfg.nixos-cloud-2.wireguard.addressIpv4;
        inherit (hostCfg) port addressIpv4 privateKeyPath range;
        mkPeer = import ./mkPeer.nix lib;
        # Extract only other peers
        peersCfg = lib.filterAttrs (n: v: n != hostname) machineCfg;
        dnsAddresses = lib.mapAttrsToList
          (n: v: "/${n}.wg/${v.wireguard.addressIpv4}")
          machineCfg;
        peers = lib.mapAttrsToList (n: mkPeer) peersCfg;
      in
      {
        # DNS instead of /etc/hosts
        services.dnsmasq = {
          enable = true;
          settings = {
            interface = "wg0";
            address = dnsAddresses ++ [
              "/alertmanager.k.joshuachp.dev/${clusterIp}"
              "/argocd.k.joshuachp.dev/${clusterIp}"
              "/atuin.k.joshuachp.dev/${clusterIp}"
              "/firefly.k.joshuachp.dev/${clusterIp}"
              "/git.k.joshuachp.dev/${clusterIp}"
              "/grafana.k.joshuachp.dev/${clusterIp}"
              "/home.k.joshuachp.dev/${clusterIp}"
              "/kubeapi.k.joshuachp.dev/${clusterIp}"
              "/kubernetes-dashboard.k.joshuachp.dev/${clusterIp}"
              "/ntfy.k.joshuachp.dev/${clusterIp}"
              "/pg.k.joshuachp.dev/${clusterIp}"
              "/prometheus.k.joshuachp.dev/${clusterIp}"
              "/syncthing.k.joshuachp.dev/${clusterIp}"
              "/traefik.k.joshuachp.dev/${clusterIp}"
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
            address = [ "${addressIpv4}/${toString range}" ];
            listenPort = port;
            privateKeyFile = privateKeyPath;
            inherit peers;
          };
        };
      }
    );
}
