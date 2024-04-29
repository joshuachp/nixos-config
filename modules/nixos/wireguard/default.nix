/*
  Wireguard configuration

  Each node has a unique ID. To each server a subnet /24 will be assigned for the given ID, also the
  node will have the IP with the same last octet as its ID.

  For example to a server with ID 5 will register the subnet 10.0.5.0/24 and will have the IP
  10.0.5.5 in the subnet.

  Each client will have an interface for each server numbered after the server's ID (e.g. wg5), and
  will be given the relative ID in the subnet with range /32. For a client with ID 2 it will be
  10.5.0.2/32.
*/
_:
{
  imports = [
    ./client.nix
    ./server.nix
  ];
}
