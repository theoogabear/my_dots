#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not found; skipping Arch packages."
    exit 0
fi

sudo pacman -Syu --needed --noconfirm \
    base-devel \
    bun \
    curl \
    fish \
    flatpak \
    git \
    github-cli \
    go \
    htop \
    jdk-openjdk \
    neovim \
    python \
    python-pip \
    rustup \
    starship \
    tmux \
    unzip \
    wget \
    xclip \
    zsh
