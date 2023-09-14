# OpenGL and hardware acceleration
{ config
, lib
, pkgs
, ...
}: {
  options = {
    nixosConfig.hardware.opengl = {
      enable = lib.options.mkOption {
        default = false;
        defaultText = "Enables OpenGL";
        description = "Enable OpenGL hardware accelleration";
        type = lib.types.bool;
      };
      intel = lib.options.mkOption {
        default = false;
        defaultText = "Enables Intel OpenGL";
        description = "Enable Intel packages for OpenGL and Vulkan hardware accelleration";
        type = lib.types.bool;
      };
      amd = lib.options.mkOption {
        default = false;
        defaultText = "Enables Amd OpenGL";
        description = "Enable Amd packages for OpenGL and Vulkan hardware accelleration";
        type = lib.types.bool;
      };
    };
  };
  config =
    let
      cfg = config.nixosConfig.hardware.opengl;
    in
    lib.mkIf cfg.enable {
      hardware.opengl = {
        enable = true;

        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          libvdpau
          vaapiVdpau
          # Vulkan
          vulkan-validation-layers
          vulkan-extension-layer
        ] ++ lib.lists.optionals cfg.intel [
          intel-media-driver
          intel-compute-runtime
          # Intel vaapi drivers
          vaapiIntel
        ] ++ lib.lists.optionals cfg.amd [
          rocm-opencl-icd
          rocm-opencl-runtime
          # Vulkan
          amdvlk
        ];

        extraPackages32 = (lib.lists.optionals cfg.amd [
          pkgs.driversi686Linux.amdvlk
        ]) ++ (lib.lists.optionals cfg.intel [
          pkgs.pkgsi686Linux.vaapiIntel
        ]);
      };

    };
}
