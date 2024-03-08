lib:
v:
let
  port = toString v.wireguard.port;
  range = toString v.wireguard.range;
  peers = v.wireguard.peers;
in
{
  inherit (v.wireguard) publicKey;
  endpoint = lib.mkIf (v.publicIpv4 != null) "${v.publicIpv4}:${port}";
  allowedIPs = [ "${v.wireguard.addressIpv4}/${range}" ] ++ peers;
  persistentKeepalive = 25;
}
