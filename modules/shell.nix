{ ... }:

{
  perSystem = { system, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nh
        pkgs.nixos-rebuild-ng
        pkgs.just
      ];
    };
  };
}
