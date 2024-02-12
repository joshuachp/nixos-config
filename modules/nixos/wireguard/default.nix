# Wireguard configuration
{ lib
, config
, ...
}:
{
  imports = [
    ./client.nix
    ./server.nix
  ];
}
