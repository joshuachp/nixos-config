{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];

    hardware.opengl = {
      enable = true;

      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        vaapiVdpau
      ];

      driSupport = true;
    };


    hardware.nvidia = {
      nvidiaPersistenced = true;

      modesetting.enable = true;

      prime = {
        sync.enable = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Specialization for using the AMD as primary GPU
    specialisation.singleMonitor.configuration = {
      hardware.nvidia = lib.mkForce {
        powerManagement = {
          enable = true;
          finegrained = true;
        };

        prime = {
          offload.enable = true;
          sync.enable = false;
        };
      };

      services.xserver.screenSection = lib.mkForce "";

      services.xserver.drivers = lib.mkForce [{
        name = "amdgpu";
        display = false;
        modules = [ pkgs.xorg.xf86videoamdgpu ];
        screenSection = ''
          GPUDevice "Device-nvidia[0]"
        '';
      }];
    };
  };
}
