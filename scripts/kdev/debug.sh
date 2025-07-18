#!/bin/bash

KERNEL="/usr/local/src/kdev/mainline-build/arch/x86/boot/bzImage"
IMAGE="/usr/local/src/kdev/trixie.img"
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
        up | upstream | mainline)
            KERNEL="/usr/local/src/kdev/mainline-build/arch/x86/boot/bzImage"
            ;;
        next)
            KERNEL="/usr/local/src/kdev/next-build/arch/x86/boot/bzImage"
            ;;
        usb)
            KERNEL="/usr/local/src/kdev/usb-build/arch/x86/boot/bzImage"
            ;;
        rust-next)
            KERNEL="/usr/local/src/kdev/rust-next-build/arch/x86/boot/bzImage"
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
    -kernel "$KERNEL" \
    -append "root=/dev/sda rw console=ttyS0 earlyprintk=serial net.ifnames=0" \
    -drive file="$IMAGE",format=raw \
    -m "$MEMORY" \
    -smp 4 \
    -netdev user,id=net0,host=10.0.2.10,hostfwd=tcp::${PORT}-:22 \
    -device virtio-net-pci,netdev=net0 \
    # -s

# -device usb-ehci,id=ehci \
# -device usb-host,vendorid=0x0489,productid=0xe0e2
