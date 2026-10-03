{
  flake.modules.nixos.preservation =
    {
      inputs,
      config,
      lib,
      ...
    }:

    # Investigate:
    # https://dsestu.github.io/knowledge/docs/nixos/impermanence.html#what-to-persist
    let
      cfg = config.homelab.impermanence;
    in
    {
      imports = [
        inputs.preservation.nixosModules.default
      ];

      options.homelab.impermanence = {
        enable = lib.mkEnableOption "Enable impermanence";

        files = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          default = [ ];
        };

        directories = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          default = [ ];
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.systemd-machine-id-commit.enable = false;

        fileSystems."/persist".neededForBoot = true;

        preservation = {
          enable = true;

          preserveAt."/persist" = {
            files = [
              {
                file = "/etc/machine-id"; # TODO: make this optional
                inInitrd = true;
              }
              {
                file = "/etc/ssh/ssh_host_ed25519_key"; # TODO: make this optional
                inInitrd = true;
              }
              # { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
              # {
              #   file = "/etc/ssh/ssh_host_ed25519_key";
              #   how = "symlink";
              #   configureParent = true;
              # }
            ]
            ++ cfg.files;
            directories = [
              "/var/lib/systemd/coredump"
              "/var/lib/systemd/rfkill"
              "/var/lib/systemd/timers"
              "/var/log"
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
            ]
            ++ cfg.directories;
          };
        };
      };
    };
}
