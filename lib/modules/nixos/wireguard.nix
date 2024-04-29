{ lib
, ...
}:
{
  config = {
    lib.config = {
      wireguard =
        let
          /**
           * Create a wireguard peer from a machine config.
           */
          mkPeer = additionalPeers: machine:
            let
              range = if machine.wireguard.server.enable then 24 else 32;
              allowedIPs = [
                "${mkServerIpv4 machine.wireguard.id}/${toString range}"
              ] ++ additionalPeers;
              port = toString machine.wireguard.server.port;
            in
            {
              inherit (machine.wireguard) publicKey;
              inherit allowedIPs;
              endpoint = lib.mkIf (machine.publicIpv4 != null) "${machine.publicIpv4}:${port}";
              persistentKeepalive = 25;
            };
          /**
           * Create a client IP in a server range
           */
          mkClientIpv4 = serverId: clientId: "10.0.${toString serverId}.${toString clientId}";
          /**
           * Create a server IP.
           */
          mkServerIpv4 = serverId: (mkClientIpv4 serverId serverId);
        in
        {
          inherit mkPeer;
          /**
           * Create a client peer from a machine config.
           */
          mkClientPeer = server: mkPeer server.wireguard.server.peers server;

          inherit mkClientIpv4 mkServerIpv4;

          /**
           * Maps the client addresses for all the servers.
           */
          mkClientAddresses = id: servers:
            lib.mapAttrsToList
              (n: v:
                let
                  ip = mkClientIpv4 v.wireguard.id id;
                in
                "${ip}/32")
              servers;

        };
    };
  };
}
