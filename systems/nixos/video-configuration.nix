{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
      # "modesetting"
      # "fbdev"
      # "amdgpu",
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
      #powerManagement = {
      #  enable = true;
      #  finegrained = true;
      #};

      nvidiaPersistenced = true;

      modesetting.enable = true;

      prime = {
        #offload.enable = true;
        sync.enable = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    environment.etc."X11/xorg.conf.d/10-amdgpu.conf".text = ''
      Section "OutputClass"
          Identifier "AMDgpu"
          MatchDriver "amdgpu"
          Driver "amdgpu"
      EndSection
    '';

    environment.etc."X11/xorg.conf.d/10-radeon.conf".text = ''
      Section "OutputClass"
          Identifier "Radeon"
          MatchDriver "radeon"
          Driver "radeon"
      EndSection
    '';

    environment.etc."X11/xorg.conf.d/10-nvidia.conf".text = ''
      Section "OutputClass"
          Identifier "nvidia"
          MatchDriver "nvidia-drm"
          Driver "nvidia"
          Option "AllowEmptyInitialConfiguration"
          Option "SLI" "Auto"
          Option "BaseMosaic" "on"
      EndSection

      Section "ServerLayout"
          Identifier "layout"
          Option "AllowNVIDIAGPUScreens"
      EndSection
    '';

    services.xserver.serverLayoutSection = lib.mkForce "";

    services.xserver.screenSection = ''
      GPUDevice "Device-amdgpu[0]"
    '';

    services.xserver.drivers = [{
      name = "amdgpu";
      display = false;
      modules = [ pkgs.xorg.xf86videoamdgpu ];
      #screenSection = ''
      #  GPUDevice "Device-nvidia[0]"
      #'';
    }];

    services.xserver.displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr} --setprovideroutputsource 1 0
      ${pkgs.xorg.xrandr} --auto
    '';

    services.xserver.displayManager.gdm.wayland = false;

    # Specialization for using the AMD as primary GPU
    specialisation."Single Monitor".configuration = {
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
