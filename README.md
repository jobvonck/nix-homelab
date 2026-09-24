Explain:

- SOPS new secret

ssh nixy 'cat /persist/etc/ssh/ssh_host_ed25519_key.pub' | ssh-to-age

[Microvm networking](https://microvm-nix.github.io/microvm.nix/routed-network.html)

Harden using
<https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop>

## Installation

1. Boot into NixOS live-usb
2. Look for device by-id for nixy/disko.nix

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
umount "/mnt/boot/efis/*"
umount -Rl "/mnt"
zpool export -a
```

Reboot

```bash
reboot
```
