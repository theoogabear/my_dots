#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_SUFFIX="backup.$(date +%Y%m%d%H%M%S)"

log() { printf '\n==> %s\n' "$*"; }

link_entry() {
    local src="$1"
    local dest="$2"
    local parent
    parent="$(dirname "$dest")"
    mkdir -p "$parent"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        printf 'linked %s\n' "$dest"
        return 0
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.$BACKUP_SUFFIX"
        printf 'backed up %s -> %s\n' "$dest" "$dest.$BACKUP_SUFFIX"
    fi

    ln -s "$src" "$dest"
    printf 'linked %s -> %s\n' "$dest" "$src"
}

link_fish_config() {
    local fish_src="$DOTFILES_ROOT/.config/fish"
    local fish_dest="$HOME/.config/fish"

    mkdir -p "$fish_dest/conf.d"
    link_entry "$fish_src/config.fish" "$fish_dest/config.fish"
    link_entry "$fish_src/fish_plugins" "$fish_dest/fish_plugins"

    for src in "$fish_src"/conf.d/*; do
        [ -e "$src" ] || continue
        link_entry "$src" "$fish_dest/conf.d/$(basename "$src")"
    done
}

log "Linking root dotfiles"
for entry in \
    .aliases \
    .bash_aliases \
    .bash_profile \
    .bashrc \
    .brewfile \
    .claude \
    .codex \
    .gemini \
    .gitconfig \
    .omp \
    .pi \
    .profile \
    .shenv \
    .zshenv \
    .zshrc
    do
    [ -e "$DOTFILES_ROOT/$entry" ] || continue
    link_entry "$DOTFILES_ROOT/$entry" "$HOME/$entry"
done

log "Linking XDG config entries"
mkdir -p "$HOME/.config"
for src in "$DOTFILES_ROOT"/.config/*; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    if [ "$name" = "fish" ]; then
        link_fish_config
    else
        link_entry "$src" "$HOME/.config/$name"
    fi
done

log "Preparing local secret files"
touch "$HOME/.secrets"
[ -e "$HOME/.secrets.fish" ] || : > "$HOME/.secrets.fish"
