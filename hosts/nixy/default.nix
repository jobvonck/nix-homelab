{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./../../modules/users/job
    ./../../modules/users/root
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

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "job" ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };

  microvm = {
    autostart = [ "test-vm" ];
    stateDir = "/var/lib/microvms";
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
