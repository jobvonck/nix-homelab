{
  flake.module.nixos.hardware-hp-pavilion-15c0900nd =
    {
      inputs,
      config,
      lib,
      ...
    }:

    {

      imports = [
        inputs.nixos-hardware.nixosModules.common-pc-laptop
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];

      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [
        "kvm-amd"
        "hp-wmi"
      ];
      boot.extraModulePackages = [ ];
    };
}
