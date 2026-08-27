{ pkgs, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 2048;
    vcpu = 1;
  };

  networking.hostName = "test-vm";

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

  users.users."job" = {
    isNormalUser = true;
    description = "job";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYNgjDzDE+ZtmPGdPIRKXBkji3xLmP2m+fETiEeP5/h job@local"
    ];
    password = "nixos";
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
