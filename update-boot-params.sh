#!/usr/bin/env bash

efibootmgr -d /dev/nvme0n1 -p 1 -c -L "Arch Linux" -l /vmlinuz-linux -u "root=/dev/nvme0n1p5 rw quiet initrd=/intel-ucode.img initrd=/initramfs-linux.img acpi_osi=! acpi_osi='Windows 2020'"
