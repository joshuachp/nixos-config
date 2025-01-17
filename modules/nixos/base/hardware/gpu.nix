# OpenGL and hardware acceleration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      nixosConfig.hardware.graphics = {
        enable = mkOption {
          default = config.systemConfig.desktop.enable;
          description = "Enable graphical hardware acceleration";
          type = lib.types.bool;
        };
        gpu = mkOption {
          description = "List of the system GPU";
          default = [ ];
          type = types.listOf (
            types.enum [
              "amd"
              "intel"
            ]
          );
        };
      };
    };
  config =
    let
      cfg = config.nixosConfig.hardware.graphics;
      amd = builtins.elem "amd" cfg.gpu;
      intel = builtins.elem "intel" cfg.gpu;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.enable && (cfg.gpu != [ ]);
          message = "Select a gpu for the hardware acceleration";
        }
      ];
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;

          extraPackages =
            (with pkgs; [
              # Vulkan
              vulkan-extension-layer
              vulkan-validation-layers
            ])
            ++ lib.optionals intel (
              with pkgs;
              [
                intel-media-driver
                intel-compute-runtime
                # imported in nixos-hardware
                # intel-vaapi-driver
                libvdpau-va-gl
              ]
            );

          extraPackages32 = lib.optionals intel [
            pkgs.pkgsi686Linux.intel-media-driver
            # imported in nixos-hardware
            # pkgs.pkgsi686Linux.intel-vaapi-driver
          ];
        };

        amdgpu = lib.mkIf amd {
          opencl.enable = true;
          initrd.enable = true;
          amdvlk = {
            enable = true;
            support32Bit.enable = true;
          };
        };
      };
    };
}
