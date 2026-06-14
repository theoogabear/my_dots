#!/usr/bin/env bash
set -euo pipefail

if ! command -v fish >/dev/null 2>&1; then
    echo "fish is not installed; install OS packages first."
    exit 0
fi

fish -c '
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    if test -f ~/.config/fish/fish_plugins
        fisher update
    end
'

fish_path="$(command -v fish)"
if ! grep -qxF "$fish_path" /etc/shells; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi

if [ "${SHELL:-}" != "$fish_path" ]; then
    chsh -s "$fish_path" || true
fi
