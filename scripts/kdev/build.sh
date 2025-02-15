#!/bin/bash

# General Config
KERNEL="$HOME/linux"
ARCH="$(uname -m)"

# Build Config
BUILD=false
LATEST=false
MOD=false

# Modules Config
MODULES="full"
MOD_PATH=""

OLD=false
MENU=false

base="ccache make -s -j $(nproc) arch=$ARCH"

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  -b <lazy>    Builds the kernel
  -l <lazy>    Update to latest (depends on git)
  -m <lazy>    Run menuconfig
  -o <lazy>    Use old config
  -n <lazy>    Install modules
  -p <path>    Modules installation path
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

while getopts "blmnok:a:M:p:h" opt; do
    case "$opt" in
        b) BUILD=true ;;
        l) LATEST=true ;;
        m) MENU=true ;;
        n) MOD=true ;;
        o) OLD=true ;;
        k) KERNEL="$OPTARG" ;;
        a) ARCH="$OPTARG" ;;
        M) MODULES="$OPTARG" ;;
        p) MOD_PATH="$OPTARG" ;;
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

run_oldconfig() {
        echo "Applying oldconfig..."
        make oldconfig
}

build_kernel() {
    echo "Build kernel with: $base"

    if "$BUILD"; then
        eval "$base"
    fi
}

build_modules() {
    local mod="modules_install"

    case "$MODULES" in
        full) ;;
        strip|stripped) mod="$mod INSTALL_MOD_STRIP=1" ;;
    esac

    if [ -n "$MOD_PATH" ]; then
        mod="$mod INSTALL_MOD_PATH=$MOD_PATH"
    fi

    local cmd_mod="$base $mod"

    echo "Build modules with: $cmd_mod"
    eval sudo $cmd_mod
}

$LATEST && update
$OLD && run_oldconfig
$MENU && run_menuconfig
$BUILD && build_kernel
$MOD && build_modules
