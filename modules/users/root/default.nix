{ pkgs, config, ... }:

{
  sops.secrets."password-root" = {
    neededForUsers = true;
    sopsFile = ./secrets.yaml;
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets."password-root".path;
  };
}
