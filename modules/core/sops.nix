{
  flake.modules.nixos.core =
    { inputs, ... }:

    {
      imports = [ inputs.sops-nix.nixosModules.default ];

      sops = {
        age = {
          sshKeyPaths = [
            "/persist/etc/ssh/ssh_host_ed25519_key"
          ];
        };
      };
    };
}
