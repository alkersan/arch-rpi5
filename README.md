# Raspberry Pi 5 image made with AArch64 Arch Linux Port

Built with a modified [mkosi](https://github.com/systemd/mkosi) that uses Arch Linux Ports mirror
<https://arch-linux-repo.drzee.net/arch>.

U-Boot provides a UEFI environment to boot the unified kernel image (UKI) built by mkinitcpio.

The `linux-rpi5` kernel is gzip-compressed, which ARM64 UKI boot path cannot load.
A pacman hook decompresses it before mkinitcpio runs.
