# Configure virtualisation
{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.nixosConfig.virtualisation;
in
{
  options = {
    nixosConfig.virtualisation.enable = lib.mkEnableOption "virtualisation";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            pkgs.OVMFFull.fd
          ];
        };
      };
    };

    environment.systemPackages = import ../../pkgs/virtualisation.nix pkgs
      ++ [
      pkgs.win-virtio
    ];
  };
}
