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
        users-root
        users-job
        preservation
        microvm-vm
        nginx
      ];

      networking.hostName = "nginx-vm";
      nixpkgs.hostPlatform = "x86_64-linux";

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
    };
}
