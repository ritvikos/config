#!/bin/bash

set -e

usage() {
    echo "Usage: $0 -b <branch> [-p <patch-subpath>]"
    echo "Automates git format-patch and checkpatch.pl"
    echo
    echo "Required Arguments:"
    echo "  -p, --patch        Location to store the patch ($HOME/patches/fixes/)"
    echo "  -b, --branch       The branch to generate patches from"
    echo "  -h, --help         Show this help message and exit"
    exit 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -p|--patch)
            PATCH_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [ -z "$BRANCH" ] || [ -z "$PATCH_DIR" ]; then
    echo "Error: Missing required parameters!"
    usage
fi

echo "$PATCH_DIR"

PATCH=$(git format-patch -o "$PATCH_DIR" "$BRANCH")
echo "Generated patch:"
echo "$PATCH"

echo "Running checkpatch.pl..."
scripts/checkpatch.pl "$PATCH" || echo "Checkpatch warnings/errors in $PATCH"

echo "Good to Go!"
