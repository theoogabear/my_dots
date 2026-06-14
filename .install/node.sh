#!/usr/bin/env bash
set -euo pipefail

NODE_VERSION="${NODE_VERSION:-24}"

if command -v fish >/dev/null 2>&1 && fish -c 'functions -q nvm' >/dev/null 2>&1; then
    fish -c "nvm install $NODE_VERSION; nvm use $NODE_VERSION"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nvm/nvm.sh"
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
elif command -v node >/dev/null 2>&1; then
    echo "node already installed: $(node --version)"
else
    echo "nvm.fish/nvm not available yet; run .install/fish.sh or install Node manually." >&2
fi
