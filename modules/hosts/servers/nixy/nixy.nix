{
  config,
  ...
}:

{
  flake.modules.nixos."hosts/nixy" =
    { pkgs, ... }:

    {
      imports = with config.flake.modules.nixos; [
        core
        users-root
        users-job
        preservation
        single-nvme-zfs

        microvm-host

        hardware-hp-pavilion-15c0900nd
      ];

      homelab = {
        storage = {
          device-id = "/dev/disk/by-id/nvme-SK_hynix_BC511_HFM256GDJTNI-82A0A_CY07N00721030763W";
          swap = {
            enable = true;
            size = "16G";
          };
        };
        impermanence = {
          enable = true;
        };
        microvm.host.enable = true;
      };

      networking.hostName = "nixy";
      networking.hostId = "8989fea7"; # TODO: find some better declarative option
      networking.networkmanager.enable = true;
      # networking.wireless.enable = true;

      systemd.network.enable = true;
      systemd.network.wait-online.enable = false;

      networking.nat = {
        enable = true;
        internalIPs = [ "10.0.0.0/24" ];
        externalInterface = "wlo1";
        forwardPorts = [
          {
            sourcePort = 80;
            proto = "tcp";
            destination = "10.0.0.2:80";
          }
          {
            sourcePort = 443;
            proto = "tcp";
            destination = "10.0.0.2:443";
          }
        ];
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.logind.settings.Login = {
        HandleLidSwitch = "lock";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "lock";
      };

      environment.systemPackages = with pkgs; [
        vim
        git
        fastfetch
        sops
        age
      ];
    };
}
