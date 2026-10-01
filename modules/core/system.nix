{
  flake.modules.nixos.core = { lib, ... }: {
    system.stateVersion = "26.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
