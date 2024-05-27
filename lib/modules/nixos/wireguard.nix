{ lib, ... }:
{
  config = {
    lib.config = {
      wireguard =
        let
          # Create a range for the given machine.
          mkCidr =
            machine:
            let
              id = toString machine.wireguard.id;
            in
            if machine.wireguard.server.enable then
              "10.0.${id}.0/${toString (mkRange machine)}"
            else
              "10.0.0.${id}/${toString (mkRange machine)}";
          # Create a machine IP with the given id
          mkIpv4 =
            machine:
            let
              inherit (machine.wireguard) id;
            in
            if machine.wireguard.server.enable then mkServerIpv4 id else mkClientIpv4 id;
          # Returns the CDIR range for the machine.
          mkRange = machine: if machine.wireguard.server.enable then 24 else 32;
          # Create a server IP with the given id
          mkServerIpv4 = serverId: "10.0.${toString serverId}.1";
          # Create a client IP with the given Id
          mkClientIpv4 = clientId: "10.0.0.${toString clientId}";
          # Create the allowedIPs for the machine
          mkIpv4Range = machine: "${mkIpv4 machine}/${toString (mkRange machine)}";
          /**
            Create a wireguard peer from a machine config.
          */
          mkPeer =
            additionalPeers: machine:
            let
              allowedIPs = [ (mkCidr machine) ] ++ additionalPeers;
              port = toString machine.wireguard.port;
            in
            {
              inherit (machine.wireguard) publicKey;
              inherit allowedIPs;
              endpoint = lib.mkIf (machine.publicIpv4 != null) "${machine.publicIpv4}:${port}";
              persistentKeepalive = 25;
            };
          # Make the interface name
          mkInterfaceName = id: "wg${toString id}";
        in
        {
          # Create a client peer from a machine config.
          mkClientPeer = server: mkPeer server.wireguard.server.peers server;
          # Create the routes to the peers.
          mkRoutes =
            server:
            let
              ip = mkServerIpv4 server.wireguard.id;
              itf = mkInterfaceName server.wireguard.id;
            in
            builtins.concatStringsSep "\n" (
              builtins.map (cdir: ''
                ip route append ${cdir} scope global nexthop dev ${itf} via ${ip} weight 1
              '') server.wireguard.server.peers
            );

          inherit
            mkPeer
            mkCidr
            mkIpv4Range
            mkRange
            mkIpv4
            mkServerIpv4
            mkClientIpv4
            mkInterfaceName
            ;
        };
    };
  };
}
