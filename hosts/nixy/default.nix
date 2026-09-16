{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./vms.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "poweroff";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "lock";
  };

  networking.hostName = "nixy";
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
        destination = "10.0.0.1:80";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    sops
    age
  ];

  system.stateVersion = "26.05";
}
