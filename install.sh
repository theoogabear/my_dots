#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(shell fish alacritty git gtk)

if ! command -v stow &>/dev/null; then
    echo "GNU Stow not found. Install it first:"
    echo "  Ubuntu/Debian: sudo apt install stow"
    echo "  Arch/CachyOS:  sudo pacman -S stow"
    exit 1
fi

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
done

echo ""
echo "Done. Post-install steps:"
echo ""
echo "  Fish plugins (fisher + nvm.fish):"
echo "    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update'"
echo ""
echo "  Rust toolchain:"
echo "    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
echo ""
echo "  Node via nvm (nvm default set to v24):"
echo "    fish -c 'nvm install 24'"
echo ""
echo "  On Ubuntu, the fish config sources CachyOS-specific files that won't exist."
echo "  See README.md for the lines to remove or replace."
