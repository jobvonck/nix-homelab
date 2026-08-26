{ ... }:

{
  sops = {
    defaultSopsFile = ../../../.sops.yaml;

    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = true;
  };
}
