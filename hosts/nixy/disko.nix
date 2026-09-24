{ ... }:

{
  # TODO: FIX ZED emails with msmtp
  # TODO: Generate config more modular
  boot.initrd.systemd.enable = true;

  # boot.initrd.systemd.services.rollback = {
  #   description = "Rollback ZFS root to blank snapshot";
  #   wantedBy = [ "initrd.target" ];
  #   after = [ "zfs-import-zroot.service" ];
  #   before = [ "sysroot.mount" ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     zfs rollback -r zroot/tank/root@blank
  #   '';
  # };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # TODO: add device dev-by-id
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # Not needed for manual
                # passwordFile = "/tmp/secret.key";
                askPassword = true;
                settings.allowDiscards = true;
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        options = {
          ashift = "12";
          # TODO: disable for hdd's
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          mountpoint = "none";
          compression = "zstd";
          relatime = "on";
          normalization = "formD";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };

        postCreateHook = ''
          zfs list -t snapshot -H -o name | grep -E '^zroot/tank/root@blank$' \
            || zfs snapshot zroot/tank/root@blank
        '';

        datasets = {
          "tank" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "tank/root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "tank/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "tank/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
        };
      };
    };
  };
}
