Explain:

- SOPS new secret

ssh nixy 'cat /persist/etc/ssh/ssh_host_ed25519_key.pub' | ssh-to-age

[Microvm networking](https://microvm-nix.github.io/microvm.nix/routed-network.html)

Harden using
<https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop>

## Installation

1. Boot into NixOS live-usb
2. Add luks password in */tmp/secret.key*
3. Look for device by-id for nixy/disko.nix
4. Run

```bash
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko --flake .#nixy
```

1. Restore */persist* or leave empty for fresh start
2. nixos-install --flake .#nixy
