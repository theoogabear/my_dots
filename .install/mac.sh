#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "mac.sh is only for macOS."
    exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -f "$DOTFILES_ROOT/.brewfile" ]; then
    brew bundle --file="$DOTFILES_ROOT/.brewfile"
fi

"$SCRIPT_DIR/rust.sh"
"$SCRIPT_DIR/bun.sh"

if [ -x "$DOTFILES_ROOT/.osx" ]; then
    "$DOTFILES_ROOT/.osx"
else
    bash "$DOTFILES_ROOT/.osx"
fi
