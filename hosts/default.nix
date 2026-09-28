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
      self.inputs.disko.nixosModules.disko
      ./nixy
    ];
  };

  nginx = mkHost {
    system = defaultSystem;
    modules = [
      ./nginx
    ];
  };

  forgejo = mkHost {
    system = defaultSystem;
    modules = [
      ./forgejo
    ];
  };
}
