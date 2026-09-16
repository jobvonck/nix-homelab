{ pkgs, ... }:

{
  homelab.microvm = {
    enable = true;
    index = 1;

    vcpu = 1;
    mem = 1024;
  };

  networking.hostName = "test-vm";

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

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    sops
    age
  ];

  system.stateVersion = "26.05";
}
