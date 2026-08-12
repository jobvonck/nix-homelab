{
  description = "A very basic flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOs/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... } : {
    nixosConfigurations."nixy" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
