{ config
, lib
, pkgs
, hostname
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
              defaults
                  retries 3
                  option  redispatch
                  timeout client 30s
                  timeout connect 4s
                  timeout server 30s


              frontend k3s-frontend
                  bind *:${toString apiPort}
                  mode tcp
                  option tcplog
                  default_backend k3s-backend

              backend k3s-backend
                  mode tcp
                  option tcp-check
                  balance roundrobin
                  default-server inter 10s downinter 5s
                  server server-1 10.0.1.1:6443 check
                  server server-2 10.0.0.2:6443 check
            '';
          };

          # VIP for the cluster
          keepalived =
            let
              script = "chk_haproxy";
            in
            {
              enable = true;
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


          k3s =
            let
              ip = config.privateConfig.machines.${hostname}.wireguard.addressIpv4;
            in
            {
              enable = true;
              clusterInit = cfg.main;
              serverAddr = lib.mkIf (!cfg.main) "https://${loadBalacerIp}:${toString apiPort}";
              tokenFile = config.sops.secrets.k3s_token.path;
              extraFlags = builtins.toString [
                "--node-ip=${ip}"
                "--secrets-encryption"
                "--disable=traefik"
                "--flannel-backend=host-gw"
                "--tls-san=${loadBalacerIp}"
              ];
            };
        };
    };
}
