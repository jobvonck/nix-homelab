Explain:

- SOPS new secret
  ssh nixy 'cat /persist/etc/ssh/ssh_host_ed25519_key.pub' | ssh-to-age

Harden using [this example](https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop)
Networking is explained in [Microvm networking](https://microvm-nix.github.io/microvm.nix/routed-network.html)

## Installation

1. Boot into NixOS live-usb
2. Look for disk id in `/dev/disk/by-id` for disko config

Partition the drives using `disko`

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko --flake .#nixy
```

> Restore */persist* or leave empty for fresh start

Install NixOS on the system

```bash
sudo nixos-install --flake .#nixy
```

Unmount the filesystems (due to different hostids)

```bash
sudo umount -Rl "/mnt"
sudo zpool export -a
```

Reboot

```bash
reboot
```
