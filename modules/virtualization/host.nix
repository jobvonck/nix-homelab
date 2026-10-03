{
  flake.modules.nixos.microvm-host =
    {
      self,
      flakeConfig,
      inputs,
      config,
      lib,
      ...
    }:

    let
      cfg = config.homelab.microvm.host;

      vmNames = {
        "nginx-vm" = 1;
        "forgejo-vm" = 2;
      };

      vmModules = flakeConfig.flake.modules.nixos;
    in
    {
      imports = [
        inputs.microvm.nixosModules.host
      ];

      options.homelab.microvm.host = {
        enable = lib.mkEnableOption "Enable MicroVM host";
      };

      config = lib.mkIf cfg.enable {
        microvm.stateDir = "/var/lib/microvms";

        microvm.vms = lib.mapAttrs (name: index: {
          specialArgs = { inherit inputs; };

          config = {
            imports = [
              vmModules.${name}
            ];

            homelab.microvm.vm.index = index;
          };
          restartIfChanged = true;
        }) vmNames;

        systemd.network.networks = lib.mapAttrs' (
          name: index:
          lib.nameValuePair "30-vm${toString index}" {
            matchConfig.Name = "vm${toString index}";

            address = [
              "10.0.0.0/32"
              "fec0::/128"
            ];

            routes = [
              {
                Destination = "10.0.0.${toString index}/32";
              }
              {
                Destination = "fec0::${lib.toHexString index}/128";
              }
            ];

            networkConfig = {
              IPv4Forwarding = true;
              IPv6Forwarding = true;
            };
          }
        ) vmNames;
      };
    };
}
