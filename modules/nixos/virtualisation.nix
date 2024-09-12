# Configure virtualisation
{
  self,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixosConfig.virtualisation;
in
{
  options = {
    nixosConfig.virtualisation = {
      enable = lib.mkEnableOption "virtualisation";
      virtualbox = lib.mkEnableOption "virtualbox";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.virtualbox {
      virtualisation.virtualbox.host.enable = true;
      users.users.joshuachp.extraGroups = [ "vboxusers" ];
    })
    (lib.mkIf cfg.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };

      environment.systemPackages = import "${self}/pkgs/virtualisation.nix" pkgs ++ [ pkgs.win-virtio ];
    })
  ];
}
