# Setup networking
{ config
, lib
, ...
}:
{
  imports = [
    ./dns.nix
  ];
  config =
    let
      isDesktop = config.systemConfig.desktop.enable;
      isServer = !isDesktop;
    in
    lib.mkMerge [
      {
        networking = {
          firewall.enable = true;
          # Allow PMTU / DHCP
          firewall.allowPing = true;

          # Use networkd by default, except on desktops
          useDHCP = lib.mkDefault false;
        };
      }
      (lib.mkIf isDesktop {
        networking.networkmanager.enable = true;
      })
      (lib.mkIf isServer {
        assertions = [{
          assertion = config.systemd.network.networks != { };
          message = "networkd networks are not configured";
        }];

        networking.useNetworkd = true;
        systemd.network = {
          enable = true;
          networks = builtins.mapAttrs
            (name: value: {
              # Disable DHCP DNS by default
              dhcpV6Config = {
                UseDNS = lib.mkDefault false;
              };
              dhcpV4Config = {
                UseDNS = lib.mkDefault false;
              };
            })
            config.systemd.network.networks;
        };
      })
    ];
}
