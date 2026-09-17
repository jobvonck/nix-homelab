{ lib, ... }:

{
  options.homelab.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence";
  };

  config = {

  };
}
