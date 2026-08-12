{ ... }:

{
  perSystem = { system, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nh
      ];
    };
  };
}
