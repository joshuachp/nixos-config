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
        inherit (config.nixosConfig.server.k3s) loadBalancerIp ingressIp;
        machine = machineCfg.${hostname};
        inherit (machine.wireguard) privateKeyPath port;
        # Function to create the peers
        inherit (config.lib.config.wireguard) mkPeer mkIpv4 mkIpv4Range;
        # Filter only other peers
        peersCfg = lib.filterAttrs
          (n: v: n != hostname)
          machineCfg;
        dnsAddresses = lib.mapAttrsToList
          (n: v: "/${n}.wg/${mkIpv4 v}")
          machineCfg;
        peers = lib.mapAttrsToList (n: (mkPeer [ ])) peersCfg;
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
            autostart = true;
            # Clients IP address subnet
            address = [ (mkIpv4Range machine) ];
            listenPort = port;
            privateKeyFile = privateKeyPath;
            inherit peers;
          };
        };
      }
    );
}
