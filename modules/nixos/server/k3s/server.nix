{
  config,
  lib,
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

      services = {
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
            "--tls-san=${cfg.ip}"
            "--tls-san=${cfg.externalIp}"
            "--tls-san=kubeapi.k.joshuachp.dev"
            # Hardening
            "--secrets-encryption"
            "--protect-kernel-defaults=true"
            # Features
            "--kube-apiserver-arg=\"--enable-admission-plugins=NodeRestriction,PodTolerationRestriction\""
          ];
        };
      };
    };
}
