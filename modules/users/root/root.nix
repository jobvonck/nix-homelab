{
  flake.modules.nixos.users-root =
    { ... }:
    {
      users.users.root = {
        # hashedPasswordFile = config.sops.secrets."password-root".path;
        password = "nixos";
      };

      sops.secrets."password-root" = {
        neededForUsers = true;
        sopsFile = ./secrets.yaml;
      };
    };
}
