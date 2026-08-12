up:
  nix flake update

check:
  nix flake check

deploy $host:
  nixos-rebuild switch --flake .#{{ host }} --target-host {{ host }} --build-host {{ host }} switch --use-remote-sudo
