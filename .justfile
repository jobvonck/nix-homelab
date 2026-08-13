host := "homelab"

default:
  @just --list

build:
  nh os build .#{{host}}

try:
  nh os test .#{{host}}

switch:
  nh os switch .#{{host}}

check:
  nix flake check

fmt:
  nix fmt

update:
  nix flake update

clean:
  nh clean all
