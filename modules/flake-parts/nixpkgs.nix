{
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = _pkg: true;
        };
        overlays = [
          (final: _prev: {
            # Pull a single package from unstable when a newer version is needed:
            #   environment.systemPackages = [ pkgs.unstable.<name> ];
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config;
              inherit system;
            };
          })
        ];
      };
    };

  flake = {
    overlays.default = _final: prev: {
      local = withSystem prev.stdenv.hostPlatform.system ({ config, ... }: config.packages);
    };
  };
}

