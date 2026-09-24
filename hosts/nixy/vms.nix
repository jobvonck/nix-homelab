{ self, lib, ... }:

let
  vmNames = [
    # "test-vm"
    # "forgejo"
  ];

  vms = lib.genAttrs vmNames (name: self.nixosConfigurations.${name});
in
{
  microvm.stateDir = "/var/lib/microvms";

  microvm.vms = lib.genAttrs vmNames (_name: {
    flake = self;
    restartIfChanged = true;
  });

  systemd.network.networks = lib.mapAttrs' (
    _name: config:
    let
      index = config.config.homelab.microvm.index;
    in
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
  ) vms;
}
