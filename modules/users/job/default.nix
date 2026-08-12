{ pkgs, ... }:
{
  users.users."job" = {
    isNormalUser = true;
    description = "job";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYNgjDzDE+ZtmPGdPIRKXBkji3xLmP2m+fETiEeP5/h job@local"
    ];
  };
}
