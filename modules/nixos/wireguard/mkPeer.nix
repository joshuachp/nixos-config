lib:
v:
let
  port = toString v.wireguard.port;
  range = toString v.wireguard.range;
in
{
  inherit (v.wireguard) publicKey;
  endpoint = lib.mkIf (v.publicIpv4 != null) "${v.publicIpv4}:${port}";
  allowedIPs = [ "${v.wireguard.addressIpv4}/${range}" ];
  persistentKeepalive = 25;
}
