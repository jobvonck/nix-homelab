{
  config,
  ...
}:

{
  flake.modules.nixos."hosts/forgejo-vm" =
    { ... }:

    {
      imports = with config.flake.modules.nixos; [
        core
        users-root
        users-job
        preservation
        microvm-vm
        nginx
      ];

      homelab = {
        impermanence = {
          enable = false;
          directories = [
            "/var/lib/acme"
          ];
        };

        microvm.vm = {
          enable = true;
          index = 1;

          vcpu = 1;
          mem = 512;
        };
      };

      networking.hostName = "forgejo-vm";
    };
}
