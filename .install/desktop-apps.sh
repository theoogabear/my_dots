#!/usr/bin/env bash
set -euo pipefail

if command -v flatpak >/dev/null 2>&1; then
    if ! flatpak remotes | grep -q '^flathub'; then
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    flatpak install -y flathub com.mitchellh.ghostty
fi

if [ "$(uname -s)" = "Linux" ] && ! command -v zed >/dev/null 2>&1 && command -v curl >/dev/null 2>&1; then
    curl -fsSL https://zed.dev/install.sh | sh
fi
