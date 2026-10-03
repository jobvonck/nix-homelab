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
          specialArgs = {
            inherit inputs;
            flakeConfig = config;
          };
          modules = [
            module
          ];
        };
      }
    ))
  ];
}
