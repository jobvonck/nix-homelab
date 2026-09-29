{
  config,
  ...
}:

{
  flake.modules.nixos."hosts/nginx-vm" =
    { ... }:

    {
      imports = with config.flake.modules.nixos; [
        core
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

      networking.hostName = "nginx-vm";
    };
}
