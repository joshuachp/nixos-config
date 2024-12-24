{ config, lib, ... }:
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
          type = types.enum [
            "main"
            "server"
            "agent"
          ];
        };
        ip = mkOption {
          description = "Node ip";
          type = types.str;
        };
        externalIp = mkOption {
          description = "Node external ip";
          type = types.str;
        };
        interface = mkOption {
          description = "Interface to connect keepalived";
          type = types.str;
        };
        ingressIp = mkOption {
          default = "10.2.0.1";
          description = "Address of the ingress";
          type = types.str;
          readOnly = true;
        };
      };
    };

  config =
    let
      cfg = config.nixosConfig.server.k3s;
    in
    lib.mkIf cfg.enable {
      networking.firewall = {
        interfaces.${cfg.interface} = {
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
        extraInputRules = ''
          # Pods & services
          ip saddr { 10.42.0.0/16, 10.43.0.0/16 } accept
        '';
      };

      # Hardening
      boot.kernel.sysctl = {
        "vm.panic_on_oom" = 0;
        "vm.overcommit_memory" = 1;
        "kernel.panic" = 10;
        "kernel.panic_on_oops" = 1;
      };

      services.k3s = {
        enable = true;
        serverAddr = "https://kubeapi.k.joshuachp.dev:6443";
        extraFlags = [
          "--kube-proxy-arg='proxy-mode=ipvs'"
          "--kube-proxy-arg='ipvs-strict-arp=true'"
        ];
      };
    };
}
