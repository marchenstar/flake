{
  services.zfs.trim.interval = "daily";
  services.zfs.trim.enable = true;
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-nvme-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              label = "esp";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [
                  "-n"
                  "ESP"
                ];
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luksroot = {
              size = "100%";
              type = "8304";
              label = "root-x86-64";
              content = {
                type = "luks";
                name = "root";
                extraFormatArgs = [
                  "--label"
                  "luksroot"
                  "--subsystem"
                  "nvme"
                ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "filesystem";
                  format = "xfs";
                  extraArgs = [
                    "-L"
                    "rootfs"
                  ];
                  mountpoint = "/";
                };
              };
            };
            slog0 = {
              size = "30G";
              label = "vdev1-slog0";
              content = {
                type = "zfs";
                pool = "data";
              };
            };
          };
        };
      };
      data0 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:17.0-ata-5";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              label = "vdev0-data0";
              size = "100%";
              content = {
                type = "zfs";
                pool = "data";
              };
            };
          };
        };
      };
      data1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:17.0-ata-6";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              label = "vdev0-data1";
              size = "100%";
              content = {
                type = "zfs";
                pool = "data";
              };
            };
          };
        };
      };
      cache0 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              label = "cache0";
              size = "100%";
              content = {
                type = "zfs";
                pool = "data";
              };
            };
          };
        };
      };
    };
    zpool = {
      data = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "mirror";
                members = [
                  "/dev/disk/by-partlabel/vdev0-data0"
                  "/dev/disk/by-partlabel/vdev0-data1"
                ];
              }
            ];
            cache = [ "/dev/disk/by-partlabel/cache0" ];
            log = [
              {
                members = [ "/dev/disk/by-partlabel/vdev1-slog0" ];
              }
            ];
          };
        };
        options = {
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          dnodesize = "auto";
          encryption = "on";
          keyformat = "raw";
          keylocation = "file:///var/lib/keyfile.bin";
          relatime = "on";
          acltype = "posixacl";
          xattr = "sa";
          utf8only = "on";
          normalization = "none";
        };
        datasets = {
          hath = {
            type = "zfs_fs";
            options = {
              atime = "off";
            };
            mountpoint = "/var/lib/hath";
          };
          home = {
            type = "zfs_fs";
            options = {
              checksum = "blake3";
            };
            mountpoint = "/home";
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
        };
      };
    };
  };
}
