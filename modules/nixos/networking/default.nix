# Setup networking
{ config, lib, ... }:
{
  imports = [
    ./dns.nix
    ./ssh.nix
  ];
  config =
    let
      isDesktop = config.systemConfig.desktop.enable;
      isServer = !isDesktop;
    in
    lib.mkMerge [
      {
        networking = {
          firewall = {
            enable = true;
            # Allow PMTU / DHCP
            allowPing = true;
          };

          # Maybe upstream
          nftables.enable = true;

          # Use networkd by default, except on desktops
          useDHCP = lib.mkDefault false;

        };

        systemd = {
          # The notion of "online" is a broken concept
          # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
          services.NetworkManager-wait-online.enable = false;
          network.wait-online.enable = false;

          services = {
            # FIXME: Maybe upstream?
            # Do not take down the network for too long when upgrading,
            # This also prevents failures of services that are restarted instead of stopped.
            # It will use `systemctl restart` rather than stopping it with `systemctl stop`
            # followed by a delayed `systemctl start`.
            systemd-networkd.stopIfChanged = false;
            # Services that are only restarted might be not able to resolve when resolved is stopped before
            systemd-resolved.stopIfChanged = false;
          };
        };
      }
      (lib.mkIf isDesktop { networking.networkmanager.enable = true; })
      (lib.mkIf isServer {
        assertions = [
          {
            assertion = config.systemd.network.networks != { };
            message = "networkd networks are not configured";
          }
        ];

        networking.useNetworkd = true;
        systemd.network.enable = true;
      })
    ];
}
