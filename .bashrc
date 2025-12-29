# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Environment Variables
export EDITOR=hx
export VISUAL=hx
export HELIX_RUNTIME="/usr/local/src/helix/runtime"

# export RUSTC="$HOME/.cargo/bin/rustc"
# export BINDGEN="/usr/bin/bindgen"
# export CC="/usr/lib64/ccache/cc"

# Path Variables
export PATH="$PATH:$HOME/go/bin/:"
export PATH="$PATH:$HOME/.cargo/bin/:"

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Completions
eval "$(task --completion bash)"

# Shortcuts
alias c=clear
alias cls=clear
alias l=ls
alias e=exit
alias d="cd ~/Desktop"
alias cl="clear && ls"
alias ..='cd ../'

alias cpu_temp='cat /sys/class/thermal/thermal_zone0/temp'
alias cr='clear && cargo r'
alias m='cd ~/Desktop && sudo ./maintain/maintenance.sh'

# Global Variables
# Kernel Development Specific
KDIR="$HOME/Desktop/linux-kernel"
KSOURCE="$KDIR/source"
KBUILD="$KDIR/builds"
CURRENT_BUILD="$KBUILD/mainline"

# Utils
alarm() {
    if [ -z "$1" ]; then
        echo "Usage: alarm <time (sec | min | hr)>"
        return 1
    fi

    date && sleep $1 && elisa ~/Music/alarm.mp3
}

clean_dnf_caches() {
    sudo dnf clean metadata
    sudo dnf clean expire-cache
    sudo dnf clean dbcache
}

# Userspace Builds
ubuild() {
    if [ -z "$1" ]; then
        echo "Error: No program name provided."
        echo "Usage: ubuild <bwrap|encl|helix|syz>"
        return 1
    fi

    PROGRAM=$1

    case "$PROGRAM" in
        hx)
	    cd /usr/local/src/helix
            cargo install \
   	    --profile opt \
   	    --config 'build.rustflags="-C target-cpu=native"' \
   	    --path helix-term \
   	    --locked	
	    hx --grammar fetch && hx --grammar build
            ;;
        *)
            echo "Error: Program '$PROGRAM' not recognized."
            return 1
            ;;
        encl)
            cd "$HOME/Desktop/oss/enclosure" || return 1
            cargo run -- --unshare-user --unshare-pid --ro-bind "/ /" /bin/bash
            ;;
        bwrap)
            cd "$HOME/Desktop/oss/bubblewrap" || return 1
            meson compile -C _builddir
            ./_builddir/bwrap --ro-bind / / --unshare-pid --unshare-user /bin/bash
            ;;
        syz)
            cd /usr/local/src/syzkaller
            git pull
            make -j $(nproc)
            ;;
    esac
}


# Kernel Development Specific
alias krgk='rg -g '!Documentation/' -g '!tools/''
alias kgdbk='gdb -tui -ex '\''target remote :1234'\'' $CURRENT_BUILD/vmlinux'
alias kdecode='"$KSOURCE"/scripts/decode_stacktrace.sh $CURRENT_BUILD/vmlinux "$KSOURCE" < '
alias build_rust_doc='cd $CURRENT_BUILD && make -C "$KSOURCE" LLVM=1 O=$(pwd) rustdoc && xdg-open Documentation/output/rust/rustdoc/kernel/index.html'

kmake() {
    local variant="${1:-rust-next}"
    local build_dir

    case "$variant" in
        mainline) build_dir="$KBUILD/mainline" ;;
        rust) build_dir="$KBUILD/rust-next" ;;
        *)
            echo "Usage: kmake [mainline|rust]"
            return 1
            ;;
    esac

    # .config should exist in $KBUILD/dir, not $KSOURCE
    cd "$KSOURCE" && make -C "$KSOURCE" O="$build_dir" menuconfig
}

kbuild() {
    local build_dir

    case "$1" in
        mainline) build_dir="$KBUILD/mainline" ;;
        rust) build_dir="$KBUILD/rust-next" ;;
        *)
            echo "Usage: kbuild [mainline|rust] compdb [optional]"
            return 1
            ;;
    esac

    if [[ "$2" == "compdb" ]]; then
        target="compile_commands.json"
    else
        target=""
    fi

    cd "$KSOURCE" || {
        echo "Kernel source not found: $KSOURCE"
        return 1
    }

    make -j"$(nproc)" O="$build_dir" LLVM=1 CLIPPY=1 ARCH=x86_64 CC="ccache clang" $target W=1

    if [[ "$2" == "compdb" ]]; then
        mv "$build_dir"/compile_commands.json "$KSOURCE"
    fi
}

kutil() {
    local cmd

    case "$1" in
        rust-analyzer) cd "$CURRENT_BUILD" && make LLVM=1 CLIPPY=1 rust-analyzer && mv rust-project.json "$KSOURCE" && cd "$KSOURCE";;
        clean) make O="$CURRENT_BUILD" clean;;
        mrproper) cd "$KSOURCE" && make ARCH="$(uname -m)" mrproper;;
        *)
            echo "Usage: kutil [rust-analyzer | clean | mrproper]"
            return 1
            ;;
    esac
}

kinstallmodules() {
    local variant="${1:-rust-next}"
    local img="$HOME/Desktop/linux-kernel/trixie.img"
    local mount_point=/mnt/trixie
    local build_dir

    case "$variant" in
        mainline) build_dir="$KBUILD/mainline" ;;
        rust) build_dir="$KBUILD/rust-next" ;;
        *)
            echo "Usage: kinstallmodules [mainline|rust]"
            return 1
            ;;
    esac

    sudo mkdir -p "$mount_point" || return 1
    sudo mount "$img" "$mount_point" || return 1

    (
        cd "$build_dir" || {
            echo "Build directory not found: $build_dir"
            sudo umount "$mount_point"
            return 1
        }

        sudo make INSTALL_MOD_PATH="$mount_point" modules_install
    )

    sudo umount "$mount_point"
}

vm() {
    local SSH_KEY="${SSH_KEY:-$HOME/.ssh/trixie.id_rsa}"
    local PORT="${PORT:-2222}"

    case "$1" in
        -ssh)
            shift
            ssh -i "$SSH_KEY" -p "$PORT" -o "StrictHostKeyChecking no" root@localhost "$@"
            ;;

        -scp-file)
            shift
            local DELETE_AFTER_COPY=false

            if [[ "$1" == "-d" ]]; then
                DELETE_AFTER_COPY=true
                shift
            fi

            local FILE_TO_COPY="${1:-repro.c}"
            local REMOTE_PATH="${2:-root@localhost:~/}"

            echo "[+] Copying '$FILE_TO_COPY' to '$REMOTE_PATH'..."
            scp -i "$SSH_KEY" -P "$PORT" "$FILE_TO_COPY" "$REMOTE_PATH"

            if [[ $? -eq 0 && "$DELETE_AFTER_COPY" == true ]]; then
                echo "[+] Deleting '$FILE_TO_COPY' after successful copy..."
                rm -f -- "$FILE_TO_COPY"
            fi
            ;;

        -scp-dir)
            shift
            local DIR_TO_COPY="${1}"
            local REMOTE_PATH="${2:-root@localhost:~/}"

            echo "[+] Copying '$DIR_TO_COPY' to '$REMOTE_PATH'..."
            scp -i "$SSH_KEY" -P "$PORT" -r "$DIR_TO_COPY" "$REMOTE_PATH"
            ;;

        *)
            echo "Usage: vm -ssh [ssh args...]"
            echo "       vm -scp-file [-d] [file] [remote-path]"
            echo "       vm -scp-dir [folder] [remote-path]"
            return 1
            ;;
    esac
}

# fnm
FNM_PATH="/home/ritvikos/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/home/ritvikos/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
