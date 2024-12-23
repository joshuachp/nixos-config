{ lib, ... }:
{
  disko.devices = {
    disk.sda = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = [ "umask=0077" ];
            };
          };
          BOOT = {
            priority = 2;
            name = "BOOT";
            start = "501M";
            end = "+1G";
            type = "EA00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "18G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              mountpoint = "/partition-root";
              mountOptions = [ "defaults" ];
              subvolumes = {
                # Subvolume name is different from mountpoint
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # Subvolume name is the same as the mountpoint
                "/home" = {
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                  mountpoint = "/home";
                };
                "/var" = {
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                  mountpoint = "/var";
                };
                "/nix" = {
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
