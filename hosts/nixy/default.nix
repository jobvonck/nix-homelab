{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./vms.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.mutableUsers = false;

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

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand"; # schedutil powersave, ondemand

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # power, balance_power

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;

      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
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
