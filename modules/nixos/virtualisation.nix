{ pkgs
, ...
}: {

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  environment.systemPackages = import ../../pkgs/virtualisation.nix pkgs
    ++ [ pkgs.win-qemu ];
}
