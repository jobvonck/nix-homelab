{
  inputs,
  lib,
  config,
  ...
}:
let
  prefix = "hosts/";
in
{
  # Read into why this works
  flake.nixosConfigurations = lib.pipe (config.flake.modules.nixos or { }) [
    (lib.filterAttrs (name: _: lib.hasPrefix prefix name))
    (lib.mapAttrs' (
      name: module:
      let
        hostname = lib.removePrefix prefix name;
      in
      {
        name = hostname;
        value = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            module
          ];
        };
      }
    ))
  ];
}
