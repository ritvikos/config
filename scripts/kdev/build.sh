#!/bin/bash

KERNEL="$HOME/linux"
ARCH="$(uname -m)"
MODULES="full"

BUILD=false
LATEST=false
MENU=false

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  -b           Builds the kernel (lazy)
  -l           Update to latest (lazy)
  -m           Run menuconfig (lazy)
  -k <path>    Kernel source directory (default: $KERNEL)
  -a <arch>    Target architecture (default: $ARCH)
  -M <type>    Modules install type: full or strip/stripped (default: $MODULES)

Example:
  $0 -k ~/custom-kernel -a arm64 -l true -m false -M stripped | strip
EOF
    exit 1
}

while getopts "blmk:a:M:h" opt; do
    case "$opt" in
        b) BUILD=true ;;
        l) LATEST=true ;;
        m) MENU=true ;;
        k) KERNEL="$OPTARG" ;;
        a) ARCH="$OPTARG" ;;
        M) MODULES="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "$KERNEL" || -z "$ARCH" || -z "$MODULES" ]]; then
    echo "Error: Missing required arguments!"
    usage
fi

cd "$KERNEL" || { echo "Error: Cannot access $KERNEL"; exit 1; }

update() {
        echo "Updating kernel source..."
        git remote -v
        git pull
}

run_menuconfig() {
        echo "Running menuconfig..."
        make menuconfig
}

build() {
    local base="ccache make -s -j $(nproc) $ARCH"
    local mod=" modules_install"

    case "$MODULES" in
        full) base+="$mod" ;;
        strip|stripped) base+="$mod INSTALL_MOD_STRIP=1" ;;
    esac

    echo "Build kernel with: $base"

    if "$BUILD"; then
        eval "$base"
    fi
}

$LATEST && update
$MENU && run_menuconfig
$BUILD && build
