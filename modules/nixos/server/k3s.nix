{ config
, lib
, pkgs
, ...
}:
{
  options =
    let
      inherit (lib) mkEnableOption mkOption types;
    in
    {
      nixosConfig.server.k3s = {
        enable = mkEnableOption "Enables k3s service";
        main = mkEnableOption "Make the node as main";
        ip = mkOption {
          description = "Node ip";
          type = types.str;
        };
        interface = mkOption {
          description = "Interface to connect keepalived";
          type = types.str;
        };
      };
    };
  config =
    let
      cfg = config.nixosConfig.server.k3s;
    in
    lib.mkIf cfg.enable {
      privateConfig.k3s.secret = true;

      users.users.keepalived_script = {
        isSystemUser = true;
        description = "keepalived script runner";
        group = "keepalived_script";
      };
      users.groups.keepalived_script = { };

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

      services =
        let
          loadBalacerIp = "10.10.10.100";
          apiPort = 56443;
        in
        {
          # Cluster load balancer configuration
          haproxy = {
            enable = true;
            config = ''
                log /dev/log  local0
                log /dev/log  local1 notice

              defaults
                retries 3
                option  redispatch
                timeout http-request 10s
                timeout queue 20s
                timeout connect 10s
                timeout client 1h
                timeout server 1h
                timeout http-keep-alive 10s
                timeout check 10s


              frontend k3s-frontend
                  bind *:${toString apiPort}
                  mode tcp
                  option tcplog
                  default_backend k3s-backend

              backend k3s-backend
                  option httpchk GET /healthz
                  http-check expect status 200
                  mode tcp
                  option ssl-hello-chk
                  balance roundrobin
                    default-server inter 10s downinter 5s
                    server server-1 10.1.0.2:6443 check
                    server server-2 10.1.0.3:6443 check
            '';
          };

          # VIP for the cluster
          keepalived =
            let
              script = "chk_haproxy";
            in
            {
              enable = true;
              openFirewall = true;
              enableScriptSecurity = true;
              vrrpScripts.${script} = {
                user = "keepalived_script";
                script = "${pkgs.procps}/bin/pidof haproxy";
                interval = 2;
              };
              vrrpInstances.haproxy-vip = {
                inherit (cfg) interface;
                state = if cfg.main then "MASTER" else "BACKUP";
                priority = if cfg.main then 200 else 100;

                virtualRouterId = 51;

                virtualIps = [{
                  addr = "${loadBalacerIp}/24";
                }];

                trackScripts = [ script ];
              };
            };

          k3s = {
            enable = true;
            clusterInit = cfg.main;
            serverAddr = lib.mkIf (!cfg.main) "https://${loadBalacerIp}:${toString apiPort}";
            tokenFile = config.sops.secrets.k3s_token.path;
            extraFlags = builtins.toString [
              "--node-ip=${cfg.ip}"
              "--secrets-encryption"
              "--disable=traefik"
              "--disable=servicelb"
              "--tls-san=${loadBalacerIp}"
              "--flannel-iface=${cfg.interface}"
            ];
          };
        };
    };
}
