{
  flake.modules.nixos.users-root =
    { config, ... }:

    {
      users.users.root = {
        hashedPasswordFile = config.sops.secrets."password-root".path;
      };

      sops.secrets."password-root" = {
        neededForUsers = true;
        sopsFile = ./secrets.yaml;
      };
    };
}
