# Raspberry Pi 5 image made with AArch64 Arch Linux Port

Built with a modified [mkosi](https://github.com/systemd/mkosi) that uses Arch Linux Ports mirror
<https://arch-linux-repo.drzee.net/arch>.

U-Boot provides a UEFI environment to the unified kernel image (UKI) built by mkinitcpio.

The `linux-rpi5` kernel is gzip-compressed, but `systemd-ukify` is able to detect that
and decompresses.
