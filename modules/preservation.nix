{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.impermanence;
in
{
  options.homelab.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence";
  };

  config = lib.mkIf cfg.enable {
    preservation = {
      enable = true;

      preserveAt."/persist" = {
        directories = [
          "/etc/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/rfkill"
          "/var/lib/systemd/timers"
          "/var/log"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
        ];

        files = [
          {
            file = "/etc/machine-id"; # TODO: make this optional
            inInitrd = true;
          }
          { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
          { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        ];
      };
    };
  };
}
