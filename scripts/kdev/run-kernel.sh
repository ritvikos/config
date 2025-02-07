#!/bin/bash

# Default path
KERNEL="$HOME/linux/arch/x86/boot/bzImage"
DRIVE="$HOME/buildroot/output/images/rootfs.ext2"

usage() {
    echo "Usage: $0 -kernel <path> -drive <path>"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -kernel)
            KERNEL="$2"
            shift 2
            ;;
        -drive)
            DRIVE="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "$KERNEL" || -z "$DRIVE" ]]; then
    echo "Error: Both -kernel and -drive arguments are required."
    usage
fi

qemu-system-x86_64 \
    -kernel "$KERNEL" \
    -drive file="$DRIVE",format=raw \
    -append "root=/dev/sda console=ttyS0" \
    -nographic -no-reboot
