{ lib
, ...
}:
{
  config = {
    lib.config =
      let
        /**
         * Create a wireguard peer from a machine config.
         */
        mkPeer = client: machine:
          let
            port = toString machine.wireguard.port;
            range = toString machine.wireguard.range;
            inherit (machine.wireguard) peers;
          in
          {
            inherit (machine.wireguard) publicKey;
            endpoint = lib.mkIf (machine.publicIpv4 != null) "${machine.publicIpv4}:${port}";
            allowedIPs = [
              "${machine.wireguard.addressIpv4}/${range}"
            ] ++ (lib.optionals client peers);
            persistentKeepalive = 25;
          };
      in
      {
        /**
         * Create a client peer from a machine config.
         */
        wireguard.mkClientPeer = mkPeer true;
        /**
         * Create a server peer from a machine config.
         */
        wireguard.mkServerPeer = mkPeer false;
      };
  };
}
