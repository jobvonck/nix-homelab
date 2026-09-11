{ pkgs, ... }:

{
  homelab.microvm = {
    enable = true;
    index = 1;

    vcpu = 1;
    mem = 1024;
  };

  networking.hostName = "test-vm";

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "job" ];
      MaxAuthTries = 10;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    sops
    age
  ];

  system.stateVersion = "26.05";
}
