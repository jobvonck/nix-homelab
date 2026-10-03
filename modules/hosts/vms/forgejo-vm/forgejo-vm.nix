{
  config,
  ...
}:

{
  flake.modules.nixos.forgejo-vm =
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

      networking.hostName = "forgejo-vm";
      nixpkgs.hostPlatform = "x86_64-linux";

      homelab = {
        impermanence = {
          enable = true;
          directories = [
            "/var/lib/acme"
          ];
        };

        microvm.vm = {
          enable = true;

          vcpu = 1;
          mem = 512;
        };
      };
    };
}
