{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.zfs.forceImportRoot = false;
  boot.supportedFilesystems = [ "zfs" ];

  # TODO:This needs tuning
  # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html
  boot.kernelParams = [
    "zfs.zfs_arc_max=2147483648"
    "zfs.zfs_arc_min=1073741824"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
