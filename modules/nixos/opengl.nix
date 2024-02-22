# OpenGL and hardware acceleration
{ config
, lib
, pkgs
, ...
}: {
  options =
    let
      cfgSystem = config.systemConfig;
      inherit (lib) mkOption types;
    in
    {
      nixosConfig.hardware.opengl = {
        enable = mkOption {
          default = cfgSystem.desktop.enable;
          description = "Enable OpenGL hardware acceleration";
          type = lib.types.bool;
        };
        gpu = mkOption {
          description = "List of the system GPU";
          type = types.listOf (types.enum [ "amd" "intel" ]);
        };
      };
    };
  config =
    let
      cfg = config.nixosConfig.hardware.opengl;
      amd = builtins.elem "amd" cfg.gpu;
      intel = builtins.elem "intel" cfg.gpu;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.enable && (cfg.gpu != [ ]);
          message = "Select a gpu for OpenGL";
        }
      ];
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware.opengl = {
        enable = true;

        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          # Vulkan
          vulkan-extension-layer
          vulkan-validation-layers
        ] ++ lib.optionals intel [
          intel-media-driver
          intel-compute-runtime
          # Intel vaapi drivers
          vaapiIntel
          libvdpau-va-gl
        ] ++ lib.optionals amd [
          # Vulkan
          amdvlk
          # Opencl
          rocmPackages.clr.icd
          rocmPackages.clr
        ];

        extraPackages32 = (lib.optionals amd [
          pkgs.driversi686Linux.amdvlk
        ]) ++ (lib.optionals intel [
          pkgs.pkgsi686Linux.vaapiIntel
        ]);
      };

    };
}
