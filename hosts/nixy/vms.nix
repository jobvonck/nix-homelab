{ self, lib, ... }:

let
  vmNames = [
    "test-vm"
  ];

  vms = lib.genAttrs vmNames (
    name: self.nixosConfigurations.${name}
  );
in
{
  microvm.stateDir = "/var/lib/microvms";

  microvm.vms = lib.genAttrs vmNames (_name: {
    flake = self;
    restartIfChanged = true;
  });
}
