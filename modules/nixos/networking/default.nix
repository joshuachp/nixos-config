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
      inherit (config.networking) networkmanager;
    in
    lib.mkMerge [
      {
        networking = {
          firewall.enable = true;
          # Allow PMTU / DHCP
          firewall.allowPing = true;

          # Use networkd by default, except on desktops
          useNetworkd = lib.mkDefault (!networkmanager.enable);
          useDHCP = lib.mkDefault false;
        };
      }
    ];
}
