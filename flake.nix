{
  description = "A very basic flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      sops-nix,
      microvm,
      disko,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        imports = [
          ./modules/shell.nix
        ];

        flake = {
          nixosConfigurations = {
            nixy = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./hosts/nixy/configuration.nix
                sops-nix.nixosModules.sops
                microvm.nixosModules.host
                {
                  microvm = {
                    stateDir = "/var/lib/microvms";
                    autostart = [
                      "test-vm"
                    ];
                  };
                }
              ];
            };

            test-vm = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";

              modules = [
                ./hosts/test-vm
                microvm.nixosModules.microvm
              ];
            };
          };
        };
      }
    );
}
