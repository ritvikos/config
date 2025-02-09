#!/bin/bash

KERNEL="$HOME/linux"
ARCH="$(uname -m)"
MODULES="full"

BUILD=false
LATEST=false
MENU=false
MOD=false

base="ccache make -s -j $(nproc) arch=$ARCH"

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  -b <lazy>    Builds the kernel
  -l <lazy>    Update to latest (depends on git)
  -m <lazy>    Run menuconfig
  -n <lazy>    Install modules
  -k <path>    Kernel source directory (default: $KERNEL)
  -a <arch>    Target architecture (default: $ARCH)
  -M <type>    Modules install type: full or strip/stripped (default: $MODULES)
  -h           This menu, list all available commands

Examples:
  1. Build the kernel with specified source dir:
     $ build.sh -b -k ~/floss/linux

  2. Pull the latest upstream version:
     $ build.sh -l

  3. Update to the latest upstream version, build the kernel, and install modules (order-independent):
     $ build.sh -l -b -n

EOF
    exit 1
}

if [ $# -eq 0 ]; then
    echo "No parameters provided!"
    usage
    exit 1
fi

while getopts "blmnk:a:M:h" opt; do
    case "$opt" in
        b) BUILD=true ;;
        l) LATEST=true ;;
        m) MENU=true ;;
        n) MOD=true ;;
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

build_kernel() {
    echo "Build kernel with: $base"

    if "$BUILD"; then
        eval "$base"
    fi
}

build_modules() {
    local mod=" modules_install"

    case "$MODULES" in
        full) base+="$mod" ;;
        strip|stripped) base+="$mod INSTALL_MOD_STRIP=1" ;;
    esac

    echo "Build modules with: $base"
    eval sudo "$base"
}

$LATEST && update
$MENU && run_menuconfig
$BUILD && build_kernel
$MOD && build_modules
