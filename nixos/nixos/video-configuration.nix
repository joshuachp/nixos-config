# NixOS video configuration
{ config, lib, ... }:
{
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables = {
      DRI_PRIME = "pci-0000_01_00_0";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Used for compute environments
      modesetting.enable = true;

      # Borked or unsupported
      forceFullCompositionPipeline = false;
      nvidiaPersistenced = false;
      dynamicBoost.enable = false;

      prime = {
        sync.enable = false;

        # offload.enableOffloadCmd = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    specialisation = {
      onTheGo.configuration = {
        system.nixos.tags = [ "onTheGo" ];

        hardware.nvidia = {
          modesetting.enable = lib.mkForce false;
          prime = {
            offload = {
              enable = lib.mkForce false;
              enableOffloadCmd = lib.mkForce false;
            };
            sync.enable = lib.mkForce false;
          };
        };

        # disable nvidia
        boot.extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';

        boot.blacklistedKernelModules = [
          "nouveau"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
        ];

        services = {
          # battery management
          power-profiles-daemon.enable = false;
          tlp = {
            enable = true;
            settings = {
              CPU_SCALING_GOVERNOR_ON_AC = "performance";
              CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

              CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
              CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            };
          };

          # Disable nvidia
          udev.extraRules = ''
            # Remove NVIDIA USB xHCI Host Controller devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
            # Remove NVIDIA USB Type-C UCSI devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
            # Remove NVIDIA Audio devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
            # Remove NVIDIA VGA/3D controller devices
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
          '';
        };

        powerManagement.cpuFreqGovernor = lib.mkForce "ondemand";
      };
    };
  };
}
