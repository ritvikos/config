#!/bin/bash

# General Config
KERNEL="$HOME/linux"
ARCH="$(uname -m)"

# Build Config
BUILD=false
LATEST=false
MOD=false
OUT_PATH=""

# Modules Config
MODULES="full"
MOD_PATH=""

OLD=false
OLDDEF=false
MENU=false

base="ccache make -s -j $(nproc) arch=$ARCH"

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  -b <lazy>    Builds the kernel
  -l <lazy>    Update to latest (depends on git)
  -o <path>    Build in specific directory

  -m <lazy>    Run menuconfig
  -x <lazy>    Use 'oldconfig'
  -d <lazy>    Use 'olddefconfig'

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

while getopts "blmnxdk:a:M:p:o:h" opt; do
    case "$opt" in
        b) BUILD=true ;;
        l) LATEST=true ;;
        m) MENU=true ;;
        n) MOD=true ;;
        x) OLD=true ;;
        d) OLDDEF=true ;;
        k) KERNEL="$OPTARG" ;;
        a) ARCH="$OPTARG" ;;
        M) MODULES="$OPTARG" ;;
        p) MOD_PATH="$OPTARG" ;;
        o) OUT_PATH="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "$KERNEL" || -z "$ARCH" || -z "$MODULES" ]]; then
    echo "Error: Missing required arguments!"
    usage
fi

if [ "$OLD" = true ] && [ "$OLDDEF" = true ]; then
    echo "Error: Both OLD and OLDDEF cannot be true."
    exit 1
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

run_olddefconfig() {
        echo "Applying olddefconfig..."
        make olddefconfig
}

build_kernel() {
    echo "buildl"
    if [ -n "$OUT_PATH" ]; then
        base+=" O=$OUT_PATH"
    fi

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
$OLDDEF && run_olddefconfig
$MENU && run_menuconfig
$BUILD && build_kernel
$MOD && build_modules
