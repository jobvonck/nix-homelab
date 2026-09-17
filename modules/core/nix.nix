{ lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
      persistent = true;
    };
    optimise = {
      automatic = false; # TODO: Make default true and override
      # dates = [ "daily" ];
    };

    settings.experimental-features = lib.mkDefault [
      "nix-command"
      "flakes"
    ];
  };
}
