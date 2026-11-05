# Raspberry Pi 5 image for AArch64 Arch Linux Port

A [mkosi](https://github.com/systemd/mkosi) Raspberry Pi 5 image builder from the
Arch Linux [AArch64 Port](https://ports.archlinux.page/aarch64/).

Requires a modified `mkosi` to point to the community ports mirror <https://arch-linux-repo.drzee.net/arch>
(see changes in the [patch](https://github.com/alkersan/mkosi/commit/8643315bec1b3734db31fa13ac2c5a6f9ee7c5ed)).


## Build

To build an image choose a kernel and boot method, then add optional feature profiles, e.g.:

```sh
mkosi build --profile=linux-rpi5,firstboot,growfs,ssh
```

The disk image is written to `mkosi.output/image.raw`.

To write it to an SD card or USB drive:

```sh
mkosi burn /dev/disk/by-id/DEVICE
```

For a minimal usable system, put a `first-boot` script into the boot partition, for example:

```sh
#!/bin/bash
set -eu

USER=arch
useradd --create-home --user-group --groups wheel --shell /bin/bash "$USER"

install -d -m 700 -o "$USER" -g "$USER" "/home/$USER/.ssh"
install -m 0600 -o "$USER" -g "$USER" /dev/stdin "/home/$USER/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAA...
EOF

# Allow passwordless run0
install -m 0644 /dev/stdin /etc/polkit-1/rules.d/49-run0-user.rules <<EOF
polkit.addRule(function(action, subject) {
    if (subject.user === "$USER" &&
        (action.id === "org.freedesktop.systemd1.manage-units" ||
         action.id === "io.systemd.PTYBroker.acquire-pty-with-shell")) {
        return polkit.Result.YES;
    }
});
EOF
```

## Profiles

Available profiles configure specific areas of the system and can be selected at build time.

- `linux-rpi5` - downstream Raspberry Pi kernel, boots directly through the rpi firmware bootloader
- `linux-rpi5-efi` - downstream Raspberry Pi kernel packaged as UKI and U-Boot for UEFI
- `linux` - current Arch Linux kernel with the Raspberry Pi 5 device tree
- `firstboot` - run the `/boot/first-boot` script, if present, during the first boot; use to automate the initial setup
- `growfs` - expand the root partition and filesystem during the first boot to use the entire disk
- `ssh` - install and enable SSH server
- `utils` - install build tools and utilities for system monitoring and debugging
- `autologin` - configure automatic login as root on the `ttyAMA10` serial console
