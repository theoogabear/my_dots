# my_dots

Portable home-directory dotfiles for new Linux and macOS desktops.

This repo mirrors `$HOME` directly, like `~/.zshrc`, `~/.config/fish/config.fish`, and `~/.codex/config.toml`. The installer links those files into place and backs up any existing destination as `*.backup.TIMESTAMP`.

## Layout

| Path | Purpose |
|---|---|
| `.install/` | Modular fresh-machine installers. |
| `.config/` | XDG app config: Fish, Git, GTK, Alacritty. |
| `.shenv`, `.zshrc`, `.bashrc`, `.profile` | Portable shell startup without machine-specific `/home/...` paths. |
| `.aliases`, `.bash_aliases` | Shared shell aliases. |
| `.claude`, `.codex`, `.gemini`, `.omp`, `.pi` | AI/agent CLI config. |
| `.brewfile`, `.osx` | macOS packages and defaults. |

## Fresh machine

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/theoogabear/my_dots/main/bootstrap.sh)
```

By default this clones to `~/.dotfiles`, links dotfiles, installs supported OS packages, runtimes, Fish plugins, AI CLIs, and desktop apps.

Useful variants:

```bash
# Only link dotfiles; no sudo/package installs.
bash install.sh --dotfiles-only

# Link dotfiles and install runtimes, but skip OS package managers.
bash install.sh --skip-packages

# Custom clone location for bootstrap.
DOTFILES_DIR="$HOME/src/my_dots" bash <(curl -fsSL https://raw.githubusercontent.com/theoogabear/my_dots/main/bootstrap.sh)
```

## Installer modules

`.install/install.sh` orchestrates these modules:

- `dotfiles.sh` links home-relative files, keeps generated Fish state local, and creates `~/.secrets` / `~/.secrets.fish`.
- `apt-packages.sh` installs Debian/Ubuntu packages.
- `pacman-packages.sh` installs Arch/CachyOS packages.
- `fish.sh` installs Fisher plugins from `.config/fish/fish_plugins` and optionally switches the login shell.
- `rust.sh`, `go.sh`, `bun.sh`, `node.sh` install language runtimes.
- `ai-clis.sh` installs Claude Code, Codex, and Gemini CLI via npm.
- `desktop-apps.sh` installs Linux desktop apps such as Ghostty/Zed when supported.
- `mac.sh` runs Homebrew Bundle from `.brewfile` and applies `.osx` defaults.

## Secrets

Do not commit API keys. Put POSIX shell secrets in `~/.secrets`:

```sh
export GEMINI_API_KEY="..."
```

Put Fish-specific secrets in `~/.secrets.fish`:

```fish
set -gx GEMINI_API_KEY "..."
```

## After install

```bash
gh auth login
exec "$SHELL" -l
```
