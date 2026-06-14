#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

install_packages=1
install_runtimes=1
install_apps=1

usage() {
    cat <<USAGE
Usage: .install/install.sh [--dotfiles-only] [--skip-packages] [--skip-runtimes] [--skip-apps]

Links dotfiles into \$HOME, then installs OS packages and developer tools when available.
USAGE
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dotfiles-only)
            install_packages=0
            install_runtimes=0
            install_apps=0
            ;;
        --skip-packages) install_packages=0 ;;
        --skip-runtimes) install_runtimes=0 ;;
        --skip-apps) install_apps=0 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

log() { printf '\n==> %s\n' "$*"; }
run() {
    log "$1"
    shift
    "$@"
}

run "Dotfiles" "$SCRIPT_DIR/dotfiles.sh"

if [ "$install_packages" -eq 1 ]; then
    case "$(uname -s)" in
        Linux)
            if command -v apt-get >/dev/null 2>&1; then
                run "Debian/Ubuntu packages" "$SCRIPT_DIR/apt-packages.sh"
            elif command -v pacman >/dev/null 2>&1; then
                run "Arch packages" "$SCRIPT_DIR/pacman-packages.sh"
            else
                echo "No supported Linux package manager found; skipping OS packages."
            fi
            ;;
        Darwin)
            run "macOS packages" "$SCRIPT_DIR/mac.sh"
            install_runtimes=0
            ;;
        *)
            echo "Unsupported OS $(uname -s); dotfiles linked only."
            install_runtimes=0
            install_apps=0
            ;;
    esac
fi

if [ "$install_runtimes" -eq 1 ]; then
    run "Fish shell and plugins" "$SCRIPT_DIR/fish.sh"
    run "Rust" "$SCRIPT_DIR/rust.sh"
    run "Go" "$SCRIPT_DIR/go.sh"
    run "Bun" "$SCRIPT_DIR/bun.sh"
    run "Node" "$SCRIPT_DIR/node.sh"
    run "AI CLIs" "$SCRIPT_DIR/ai-clis.sh"
fi

if [ "$install_apps" -eq 1 ] && [ "$(uname -s)" = "Linux" ]; then
    run "Desktop apps" "$SCRIPT_DIR/desktop-apps.sh"
fi

log "Done"
echo "Next: gh auth login; add secrets to ~/.secrets and ~/.secrets.fish; restart your shell."
