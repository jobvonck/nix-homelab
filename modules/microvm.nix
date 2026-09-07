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
    enable = lib.mkEnableOption "Microvm";

    inherit (options.microvm) vcpu mem;

    index = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
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
      ];

    };
  };
}
