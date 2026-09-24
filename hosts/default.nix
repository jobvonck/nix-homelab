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
        self.inputs.preservation.nixosModules.default
        ./../modules
      ]
      ++ modules;
    };

  mkGuest =
    { system, modules }:
    mkHost {
      inherit system;

      modules = [
        self.inputs.microvm.nixosModules.microvm
        ./../modules/microvm.nix
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

  test-vm = mkGuest {
    system = defaultSystem;
    modules = [
      ./test-vm
    ];
  };

  forgejo = mkGuest {
    system = defaultSystem;
    modules = [
      ./forgejo
    ];
  };
}
