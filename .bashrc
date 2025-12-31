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

# Kernel Development Workflow

declare -A K_VARIANTS=(
    ["mainline"]="mainline"
    ["rust"]="rust"
)

k() {
    local KSOURCE="${KSOURCE:-$HOME/src/linux}"
    local KBUILD="${KBUILD:-$HOME/build/linux}"
    local IMAGE="$KDIR/trixie.img"
    local MNT="/mnt/trixie"

    _k_err() { echo "Error: $1" >&2; return 1; }

    _k_usage() {
        cat <<EOF
Usage: k <command> [arguments]

Commands:
  config  <variant>           Run menuconfig for a specific variant
  build   <variant> [compdb]  Build kernel (optionally generate compile_commands.json)
  util    <action> <variant>  Run utility actions: clean, mrproper, rust-analyzer
  modules <variant>           Mount image and install kernel modules
  rg      [args]              Search source (excludes Documentation/ and tools/)
  gdb     <variant>           Remote GDB session (target :1234)
  decode  <variant> < log     Decode stacktrace using variant vmlinux
  doc     <variant>           Build and open Rust documentation

Variants: ${!K_VARIANTS[*]}
EOF
        return 1
    }

    [[ ! -d "$KSOURCE" ]] && { _k_err "Source directory not found: $KSOURCE" || return 1; }

    local cmd="$1"
    local action var opt build_dir

    case "$cmd" in
        util)
            action="$2"; var="$3"
            [[ -z "$action" ]] && { _k_usage || return 1; }
            ;;
        config|build|modules|gdb|decode|doc)
            var="$2"; opt="$3"
            [[ -z "$var" ]] && { _k_usage || return 1; }
            ;;
        rg) ;;
        *) { _k_usage || return 1; } ;;
    esac

    if [[ -n "$var" ]]; then
        [[ -z "${K_VARIANTS[$var]}" ]] && { _k_err "Invalid variant '$var'" || return 1; }
        build_dir="$KBUILD/${K_VARIANTS[$var]}"
        if [[ "$cmd" != "config" && ! -d "$build_dir" ]]; then
            _k_err "Build directory missing: $build_dir. Run 'k config $var' first." || return 1
        fi
    fi

    case "$cmd" in
        config)
            mkdir -p "$build_dir"
            make -C "$KSOURCE" O="$build_dir" menuconfig
            ;;

        build)
            local target=""
            [[ "$opt" == "compdb" ]] && target="compile_commands.json"
            make -C "$KSOURCE" -j"$(nproc)" O="$build_dir" \
                LLVM=1 CLIPPY=1 ARCH=x86_64 \
                CC="ccache clang" W=1 $target || return 1
            [[ -f "$build_dir/$target" ]] && mv "$build_dir/$target" "$KSOURCE/"
            ;;

        util)
            case "$action" in
                rust-analyzer)
                    make -C "$KSOURCE" O="$build_dir" LLVM=1 CLIPPY=1 rust-analyzer || return 1
                    [[ -f "$build_dir/rust-project.json" ]] && mv "$build_dir/rust-project.json" "$KSOURCE/"
                    ;;
                clean)
                    make -C "$KSOURCE" O="$build_dir" clean
                    ;;
                mrproper)
                    make -C "$KSOURCE" ARCH="$(uname -m)" mrproper
                    ;;
                *) _k_err "Invalid action '$action'" || return 1 ;;
            esac
            ;;

        rg)
            [[ -z "$2" ]] && { _k_err "Search pattern required" || return 1; }
            rg -g '!Documentation/' -g '!tools/' "$2" "${@:3}" "$KSOURCE"
            ;;

        gdb|decode|doc)
            local vmlinux="$build_dir/vmlinux"
            [[ ! -f "$vmlinux" ]] && { _k_err "vmlinux not found at $vmlinux" || return 1; }

            case "$cmd" in
                gdb)    gdb -tui -ex 'target remote :1234' "$vmlinux" ;;
                decode) "$KSOURCE/scripts/decode_stacktrace.sh" "$vmlinux" "$KSOURCE" ;;
                doc)    make -C "$KSOURCE" O="$build_dir" LLVM=1 rustdoc && \
                        xdg-open "$build_dir/Documentation/output/rust/rustdoc/kernel/index.html" ;;
            esac
            ;;

        modules)
            [[ ! -f "$IMAGE" ]] && { _k_err "Image file missing: $IMAGE" || return 1; }
            sudo mkdir -p "$MNT"
            sudo mount "$IMAGE" "$MNT" || return 1
            trap 'sudo umount "$MNT" 2>/dev/null' EXIT
            sudo make -C "$KSOURCE" O="$build_dir" INSTALL_MOD_PATH="$MNT" modules_install
            ;;
    esac
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
