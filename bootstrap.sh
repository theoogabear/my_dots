#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/theoogabear/my_dots.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BRANCH="${DOTFILES_BRANCH:-main}"

if [ -d "$DOTFILES_DIR/.git" ]; then
    git -C "$DOTFILES_DIR" pull --ff-only
else
    git clone --branch "$BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

exec "$DOTFILES_DIR/.install/install.sh" "$@"
