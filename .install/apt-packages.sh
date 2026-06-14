#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not found; skipping Debian/Ubuntu packages."
    exit 0
fi

sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    default-jdk \
    fish \
    flatpak \
    fonts-roboto \
    git \
    gh \
    gnupg \
    htop \
    neovim \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    tmux \
    unzip \
    wget \
    xclip \
    zsh

if apt-cache show capitaine-cursors >/dev/null 2>&1; then
    sudo apt-get install -y capitaine-cursors
fi
