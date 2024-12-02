{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    let
      cfg = config.nixosConfig.server.k3s;
      isMain = cfg.role == "main";
      enable = cfg.enable && (isMain || (cfg.role == "server"));
    in
    lib.mkIf enable {
      privateConfig.k3s.token.server = true;

      users.users.keepalived_script = {
        isSystemUser = true;
        description = "keepalived script runner";
        group = "keepalived_script";
      };
      users.groups.keepalived_script = { };

      services =
        let
          inherit (cfg) loadBalancerIp apiPort;
        in
        {
          # K3s server config
          k3s = {
            tokenFile = config.sops.secrets.k3s_server_token.path;
            clusterInit = isMain;
            role = "server";
            extraFlags = [
              # Prevents issues with multiple network interfaces
              "--node-ip=${cfg.ip}"
              "--node-external-ip=${cfg.externalIp}"
              "--flannel-iface=${cfg.interface}"
              # Those are managed in the cluster
              "--disable=traefik"
              "--disable=servicelb"
              # Create a valid load-balancer https certificate for the keepalived IP and the custom
              # domain name
              "--tls-san=${cfg.loadBalancerIp}"
              "--tls-san=kubeapi.k.joshuachp.dev"
              # Hardening
              "--secrets-encryption"
              "--protect-kernel-defaults=true"
              # Features
              "--kube-apiserver-arg=\"--enable-admission-plugins=NodeRestriction,PodTolerationRestriction\""
            ];
          };

          # Cluster load balancer configuration
          haproxy = {
            enable = true;
            config = ''
                log /dev/log  local0
                log /dev/log  local1 notice

              defaults
                log global
                option  httplog
                option  dontlognull
                option  redispatch
                retries 3
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
                  mode tcp
                  option tcp-check
                  balance roundrobin
                  default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
                    server server-1 10.1.0.2:6443 check
                    server server-2 10.1.0.3:6443 check
                    server server-3 10.1.0.4:6443 check
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
                state = if isMain then "MASTER" else "BACKUP";
                priority = if isMain then 200 else 100;

                virtualRouterId = 51;

                virtualIps = [ { addr = "${loadBalancerIp}/24"; } ];

                trackScripts = [ script ];
              };
            };
        };
    };
}
