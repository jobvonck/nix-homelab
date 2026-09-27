{ self, ... }:

let
  defaultSystem = "x86_64-linux";
  mkHost =
    { system, modules }:
    self.inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit self; };
      modules = [
        self.inputs.sops-nix.nixosModules.default
        ./../modules
      ]
      ++ modules;
    };
in
{
  nixy = mkHost {
    system = defaultSystem;
    modules = [
      self.inputs.microvm.nixosModules.host
      self.inputs.disko.nixosModules.disko
      ./nixy
    ];
  };

  test-vm = mkHost {
    system = defaultSystem;
    modules = [
      ./test-vm
    ];
  };

  forgejo = mkHost {
    system = defaultSystem;
    modules = [
      ./forgejo
    ];
  };
}
