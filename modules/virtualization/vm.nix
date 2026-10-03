{
  flake.modules.nixos.microvm-vm =
    {
      inputs,
      config,
      options,
      lib,
      ...
    }:

    let
      cfg = config.homelab.microvm.vm;
    in
    {
      imports = [
        inputs.microvm.nixosModules.microvm
      ];

      options.homelab.microvm.vm = {
        enable = lib.mkEnableOption "Enable MicroVM";

        inherit (options.microvm) vcpu mem;

        index = lib.mkOption {
          type = lib.types.ints.positive;
        };

        # TODO: Generate stable mac based on index
        mac = lib.mkOption {
          type = lib.types.str;
          default = "00:00:00:00:00:01";
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.network.enable = true;

        microvm = {
          hypervisor = "qemu";
          inherit (cfg) vcpu mem;

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
            id = "vm${toString cfg.index}";
            type = "tap";
            inherit (cfg) mac;
          }
        ];

        systemd.network.networks."10-eth" = {
          matchConfig.MACAddress = config.homelab.microvm.vm.mac;

          address = [
            "10.0.0.${toString cfg.index}/32"
            "fec0::${lib.toHexString cfg.index}/128"
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
      };
    };
}
