{ config, lib, ... }:
{
  config =
    let
      cfg = config.nixosConfig.server.k3s;
      enable = cfg.enable && (cfg.role == "agent");
    in
    lib.mkIf enable {
      privateConfig.k3s.token.agent = true;

      # K3s server config
      services.k3s = {
        tokenFile = config.sops.secrets.k3s_agent_token.path;
        role = "agent";
        extraFlags = builtins.toString [
          # Prevents issues with multiple network interfaces
          "--node-ip=${cfg.ip}"
          "--flannel-iface=${cfg.interface}"
          # Hardening
          "--protect-kernel-defaults=true"
        ];
      };
    };
}
