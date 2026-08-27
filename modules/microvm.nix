{
  config,
  options,
  ...
}:

{
  options.homelab.microvm = {
    inherit (options.microvm) vcpu mem;
  };

  config.microvm = {
    hypervisor = "qemu";

    inherit (config.homelab.microvm) vcpu mem;
  };
}
