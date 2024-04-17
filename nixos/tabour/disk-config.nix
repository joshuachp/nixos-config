{ lib
, ...
}:
{
  disko.devices = {
    disk.nvme0n1 = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
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
          boot = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          };
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
              mountOptions = [
                "defaults"
              ];
              subvolumes = {
                # Subvolume name is different from mountpoint
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "defaults" "compress=zstd" "noatime" ];
                };
                # Subvolume name is the same as the mountpoint
                "/home" = {
                  mountOptions = [ "defaults" "compress=zstd" ];
                  mountpoint = "/home";
                };
                "/var" = {
                  mountOptions = [ "defaults" "compress=zstd" ];
                  mountpoint = "/var";
                };
                "/nix" = {
                  mountOptions = [ "defaults" "compress=zstd" "noatime" ];
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
