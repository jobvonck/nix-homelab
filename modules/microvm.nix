{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.homelab.microvm;
in
{
  options.homelab.microvm = {
    enable = lib.mkEnableOption "Enable MicroVM";

    inherit (options.microvm) vcpu mem;

    index = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
    };

    # TODO: Generate stable mac based on index
    mac = lib.mkOption {
      type = lib.types.str;
      default = "00:00:00:00:00:01";
    };
  };

  config = lib.mkIf cfg.enable {
    homelab = {
      impermanence.enable = true;
    };

    systemd.network.enable = true;

    microvm = {
      hypervisor = "qemu";
      inherit (config.homelab.microvm) vcpu mem;

      shares = [
        {
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }
        {
          source = "/persist/var/lib/microvms/${config.networking.hostName}/persist"; # TODO: add statedir as source
          mountPoint = "/persist";
          tag = "persist";
          proto = "virtiofs";
        }
      ];
    };

    microvm.interfaces = [
      {
        id = "vm${toString config.homelab.microvm.index}";
        type = "tap";
        inherit (config.homelab.microvm) mac;
      }
    ];

    systemd.network.networks."10-eth" = {
      matchConfig.MACAddress = config.homelab.microvm.mac;

      address = [
        "10.0.0.${toString config.homelab.microvm.index}/32"
        "fec0::${lib.toHexString config.homelab.microvm.index}/128"
      ];

      routes = [
        {
          # A route to the host
          Destination = "10.0.0.0/32";
          GatewayOnLink = true;
        }
        {
          # Default route
          Destination = "0.0.0.0/0";
          Gateway = "10.0.0.0";
          GatewayOnLink = true;
        }
        {
          # Default route
          Destination = "::/0";
          Gateway = "fec0::";
          GatewayOnLink = true;
        }
      ];
      networkConfig = {
        DNS = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
      };
    };

    sops = {
      age = {
        sshKeyPaths = [
          "/persist/etc/ssh/ssh_host_ed25519_key"
        ];
      };
    };
  };
}
