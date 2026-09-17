{ pkgs, ... }:

{
  homelab.microvm = {
    enable = true;
    index = 2;

    vcpu = 1;
    mem = 1024;
  };

  networking.hostName = "forgejo";

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works v2.0</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  system.stateVersion = "26.05";
}
