#!/bin/bash

KDIR="$HOME/Desktop/linux-kernel"
BUILD_DIR="$KDIR/builds"
CURRENT_DIR="$BUILD_DIR/mainline"
KERNEL="$CURRENT_DIR/arch/x86/boot/bzImage"

IMAGE="$KDIR/trixie.img"
MEMORY="4G"
PORT="2222"
QEMU_NET="user,host=10.0.2.25,hostfwd=tcp::${PORT}-:22"

usage() {
    echo "Usage: $0 [qemu-options]"
    echo
    echo "QEMU Options:"
    echo "  -t <type>        Type of kernel build (upstream or next)"
    echo "  -k <kernel>      Path to kernel image (default: $KERNEL)"
    echo "  -i <image>       Path to disk image (default: $IMAGE)"
    echo "  -m <memory>      Memory size (default: $MEMORY)"
    echo "  -p <port>        SSH forwarding port (default: $PORT)"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t)
            KERNEL_TYPE="$2"
            shift 2
            ;;
        -k) KERNEL="$2"; shift 2 ;;
        -i) IMAGE="$2"; shift 2 ;;
        -m) MEMORY="$2"; shift 2 ;;
        -p) PORT="$2"; shift 2 ;;
        -h|--help) usage ;;
        *)
            echo "Error: Invalid argument '$1'"
            usage
            ;;
    esac
done

if [ -n "$KERNEL_TYPE" ]; then
    case "$KERNEL_TYPE" in
        mainline)
            KERNEL="$BUILD_DIR/mainline/arch/x86/boot/bzImage"
            ;;
        next)
            KERNEL="$BUILD_DIR/mainline-next/arch/x86/boot/bzImage"
            ;;
        usb)
            KERNEL="$BUILD_DIR/usb/arch/x86/boot/bzImage"
            ;;
        nova)
            KERNEL="$BUILD_DIR/nova-next/arch/x86/boot/bzImage"
            ;;
        rust)
            KERNEL="$BUILD_DIR/rust-next/arch/x86/boot/bzImage"
            ;;
        *)
            echo "Invalid kernel type: $KERNEL_TYPE"
            usage
            ;;
    esac
fi

QEMU_NET="user,host=10.0.2.10,hostfwd=tcp::${PORT}-:22"

echo "[+] Starting QEMU..."
qemu-system-x86_64 \
    --enable-kvm \
    -cpu host \
    -kernel "$KERNEL" \
    -append "root=/dev/sda rw console=ttyS0 earlyprintk=serial net.ifnames=0 lockdown=none" \
    -drive file="$IMAGE",format=raw \
    -m "$MEMORY" \
    -smp 4 \
    -netdev user,id=net0,host=10.0.2.10,hostfwd=tcp::${PORT}-:22 \
    -device virtio-net-pci,netdev=net0 \
    -device virtio-vga
    # -device vfio-pci,host=01:00.1
    # -device vfio-pci,host=01:00.0,multifunction=on \
    # -s

# -device usb-ehci,id=ehci \
# -device usb-host,vendorid=0x0489,productid=0xe0e2
