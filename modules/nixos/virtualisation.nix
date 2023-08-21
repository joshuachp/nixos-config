{ pkgs
, ...
}: {

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
}
