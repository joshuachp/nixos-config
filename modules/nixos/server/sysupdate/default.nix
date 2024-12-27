{ hostname }:
{
  imports = [
    ./uki.nix
  ];
  config = {
    boot.uki.name = hostname;
  };
}
