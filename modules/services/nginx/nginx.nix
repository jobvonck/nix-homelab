{
  flake.modules.nixos.nginx = { config, ... }: {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        # Add HSTS header without preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Disable embedding as a frame
        add_header X-Frame-Options DENY;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;

        # This might create errors
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

      virtualHosts."git.jobvonck.nl" = {
        forceSSL = false;
        enableACME = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/" = {
          return = "200 '<html><body><h1>Nginx HTTPS works</h1></body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
      virtualHosts.localhost = {
        locations."/" = {
          return = "200 '<html><body>It works</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "abuse@jobvonck.nl";
      certs."jobvonck.nl" = {
        domain = "jobvonck.nl";
        dnsProvider = "transip";
        dnsPropagationCheck = true;
        environmentFile = config.sops.templates."transip-acme.env".path;
      };
    };

    sops.secrets."transip-account-name" = {
      sopsFile = ./secrets.yaml;
      owner = "acme";
      group = "acme";
      mode = "0400";
    };

    sops.secrets."transip-private-key" = {
      sopsFile = ./secrets.yaml;
      owner = "acme";
      group = "acme";
      mode = "0400";
    };

    sops.templates."transip-acme.env" = {
      owner = "acme";
      group = "acme";
      mode = "0400";

      content = ''
        TRANSIP_ACCOUNT_NAME=${config.sops.placeholder."transip-account-name"}
        TRANSIP_PRIVATE_KEY_PATH=${config.sops.secrets."transip-private-key".path}
      '';
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
