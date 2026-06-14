#!/usr/bin/env bash
# Fresh Ubuntu setup — run once after install.
# Usage: bash <(curl -sL https://raw.githubusercontent.com/theoogabear/my_dots/main/bootstrap.sh)
set -euo pipefail

DOTFILES_REPO="https://github.com/theoogabear/my_dots.git"
DOTFILES_DIR="$HOME/my_dots"
GO_VERSION="1.24.4"  # check go.dev/dl for newer

log()  { echo ""; echo "==> $*"; }
skip() { echo "    (already installed, skipping)"; }

# ---------------------------------------------------------------------------
log "System packages"
# ---------------------------------------------------------------------------
sudo apt-get update -qq

# GitHub CLI repo
if ! command -v gh &>/dev/null; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq
fi

sudo apt-get install -y \
    git curl wget stow build-essential \
    fish \
    gh \
    capitaine-cursors \
    default-jdk \
    python3 python3-pip python3-venv \
    flatpak

# .NET 9 (in Ubuntu 24.04 repos; on 22.04 add Microsoft feed manually)
if ! command -v dotnet &>/dev/null; then
    sudo apt-get install -y dotnet-sdk-9.0 2>/dev/null \
        || echo "    dotnet-sdk-9.0 not in apt — grab it from https://dotnet.microsoft.com/download"
fi

# ---------------------------------------------------------------------------
log "Dotfiles"
# ---------------------------------------------------------------------------
if [ -d "$DOTFILES_DIR/.git" ]; then
    git -C "$DOTFILES_DIR" pull --ff-only
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi
bash "$DOTFILES_DIR/install.sh"

# Strip CachyOS-specific source lines that don't exist on Ubuntu
sed -i '/source \/usr\/share\/cachyos-zsh-config/d'  "$HOME/.zshrc"                    2>/dev/null || true
sed -i '/source \/usr\/share\/cachyos-fish-config/d' "$HOME/.config/fish/config.fish"  2>/dev/null || true

# ---------------------------------------------------------------------------
log "Fish as default shell"
# ---------------------------------------------------------------------------
FISH_PATH="$(command -v fish)"
grep -qxF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells
if [ "$SHELL" != "$FISH_PATH" ]; then
    chsh -s "$FISH_PATH"
    echo "    Shell changed — takes effect on next login."
else
    skip
fi

# ---------------------------------------------------------------------------
log "Fisher + Fish plugins"
# ---------------------------------------------------------------------------
fish -c '
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
        | source && fisher install jorgebucaran/fisher
    fisher update
'

# ---------------------------------------------------------------------------
log "Node 24 via nvm.fish"
# ---------------------------------------------------------------------------
fish -c 'nvm install 24'

# ---------------------------------------------------------------------------
log "AI CLIs (claude, codex, gemini)"
# ---------------------------------------------------------------------------
fish -c 'nvm use 24; npm i -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli'

# ---------------------------------------------------------------------------
log "Rust"
# ---------------------------------------------------------------------------
if command -v rustup &>/dev/null; then
    skip
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# ---------------------------------------------------------------------------
log "Go $GO_VERSION"
# ---------------------------------------------------------------------------
if command -v go &>/dev/null; then
    skip
else
    GOTAR="go${GO_VERSION}.linux-amd64.tar.gz"
    curl -OL "https://go.dev/dl/$GOTAR"
    sudo tar -C /usr/local -xzf "$GOTAR"
    rm "$GOTAR"
    fish -c 'fish_add_path /usr/local/go/bin'
fi

# ---------------------------------------------------------------------------
log "Bun"
# ---------------------------------------------------------------------------
if command -v bun &>/dev/null; then
    skip
else
    curl -fsSL https://bun.sh/install | bash
fi

# ---------------------------------------------------------------------------
log "Neovim (latest AppImage)"
# ---------------------------------------------------------------------------
if command -v nvim &>/dev/null; then
    skip
else
    mkdir -p "$HOME/.local/bin"
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage \
        -o "$HOME/.local/bin/nvim"
    chmod +x "$HOME/.local/bin/nvim"
fi

# ---------------------------------------------------------------------------
log "Alacritty"
# ---------------------------------------------------------------------------
if command -v alacritty &>/dev/null; then
    skip
else
    ALACRITTY_URL=$(curl -s https://api.github.com/repos/alacritty/alacritty/releases/latest \
        | grep "browser_download_url.*Alacritty-v.*-ubuntu_24_04_amd64.deb" \
        | cut -d'"' -f4)
    if [ -n "$ALACRITTY_URL" ]; then
        curl -L "$ALACRITTY_URL" -o /tmp/alacritty.deb
        sudo dpkg -i /tmp/alacritty.deb
        rm /tmp/alacritty.deb
    else
        echo "    No .deb found for this Ubuntu version — install manually or via cargo:"
        echo "    cargo install alacritty"
    fi
fi

# ---------------------------------------------------------------------------
log "Zed editor"
# ---------------------------------------------------------------------------
if command -v zed &>/dev/null; then
    skip
else
    curl -f https://zed.dev/install.sh | sh
fi

# ---------------------------------------------------------------------------
log "Ghostty (Flatpak)"
# ---------------------------------------------------------------------------
if flatpak list 2>/dev/null | grep -q ghostty; then
    skip
else
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install --user -y flathub com.mitchellh.ghostty
fi

# ---------------------------------------------------------------------------
log "Gemini CLI + Antigravity"
# ---------------------------------------------------------------------------
# Gemini CLI is installed via npm (done above in the AI CLIs step).
# Antigravity is Google's separate agent CLI — install via their script.
if command -v agy &>/dev/null; then
    skip
else
    curl -sSL https://dl.google.com/antigravity/install.sh | bash
fi

# ---------------------------------------------------------------------------
log "Python ADK venv"
# ---------------------------------------------------------------------------
if [ -d "$HOME/adk-env" ]; then
    skip
else
    python3 -m venv "$HOME/adk-env"
fi

# ---------------------------------------------------------------------------
echo ""
echo "================================================================"
echo " All done."
echo ""
echo " Next steps:"
echo "   1. gh auth login              (GitHub CLI)"
echo "   2. Set your GEMINI_API_KEY in ~/.zshrc / ~/.config/fish/config.fish"
echo "   3. Log out and back in        (Fish shell + Flatpak take effect)"
echo "   4. If fish_user_paths are wrong, run: fish_add_path <your paths>"
echo "================================================================"
