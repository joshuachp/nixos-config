{ config
, lib
, ...
}:
{
  imports = [
    ./agent.nix
    ./server.nix
  ];
  options =
    let
      inherit (lib) mkEnableOption mkOption types;
    in
    {
      nixosConfig.server.k3s = {
        enable = mkEnableOption "Enables k3s service";
        role = mkOption {
          description = "Make the node as main";
          type = types.enum [ "main" "server" "agent" ];
        };
        ip = mkOption {
          description = "Node ip";
          type = types.str;
        };
        interface = mkOption {
          description = "Interface to connect keepalived";
          type = types.str;
        };
        loadBalacerIp = mkOption {
          default = "10.10.10.100";
          description = "Address of the API server load balancer";
          type = types.str;
          readOnly = true;
        };
        apiPort = mkOption {
          default = 56443;
          description = "Port of the API load balancer";
          type = types.port;
          readOnly = true;
        };
      };
    };

  config =
    let
      cfg = config.nixosConfig.server.k3s;
    in
    lib.mkIf cfg.enable {
      networking.firewall.interfaces.${cfg.interface} = {
        allowedTCPPorts = [
          # Etcd
          2379
          2380
          # Api
          6443
          # Metrics
          10250
          # Embedded registry
          5001

          # Metallb
          7472
          7946
        ];
        allowedUDPPorts = [
          # Wireguard
          51820
          51821
          # Flannel VXLAN
          8472
          # Metallb
          7472
          7946
        ];
      };

      # Hardening
      boot.kernel.sysctl = {
        "vm.panic_on_oom" = 0;
        "vm.overcommit_memory" = 1;
        "kernel.panic" = 10;
        "kernel.panic_on_oops" = 1;
      };

      services.k3s =
        let
          inherit (cfg) loadBalacerIp apiPort;
        in
        {
          enable = true;
          serverAddr = "https://${loadBalacerIp}:${toString apiPort}";
          extraFlags = builtins.toString [
            # Prevents issues with multiple network interfaces
            "--node-ip=${cfg.ip}"
            "--flannel-iface=${cfg.interface}"
            # Since all nodes should be connected
            "--flannel-backend=host-gw"
            # Those are managed in the cluster
            "--disable=traefik"
            "--disable=servicelb"
            # Create a valid load-balancer https certificate for the keepalived IP and the custom
            # domain name
            "--tls-san=${loadBalacerIp}"
            "--tls-san=kubeapi.k.joshuachp.dev"
            # Hardening
            "--secrets-encryption"
            "--protect-kernel-defaults=true"
          ];
        };
    };
}
