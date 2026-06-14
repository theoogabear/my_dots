# my_dots

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a Stow package. Stow symlinks its contents into `$HOME`, so `fish/.config/fish/config.fish` becomes `~/.config/fish/config.fish`.

| Package | Contents |
|---|---|
| `shell` | `.zshrc`, `.zshenv`, `.bashrc`, `.bash_profile`, `.profile` |
| `fish` | Fish shell config, `conf.d/`, `fish_plugins`, `fish_variables` |
| `alacritty` | Alacritty terminal config (Nord colors, 80% opacity) |
| `git` | `.gitconfig`, global `.config/git/ignore` |
| `gtk` | GTK 3/4 `settings.ini`, `.gtkrc-2.0` (Breeze-Dark, capitaine-cursors) |

## Install

```bash
git clone https://github.com/theoogabear/my_dots.git ~/my_dots
cd ~/my_dots
bash install.sh
```

Requires `stow`:
```bash
# Ubuntu/Debian
sudo apt install stow

# Arch/CachyOS
sudo pacman -S stow
```

## Ubuntu migration notes

A few configs reference CachyOS-specific paths that won't exist on Ubuntu. Remove or replace these lines after installing:

**`~/.config/fish/config.fish`** — remove:
```fish
source /usr/share/cachyos-fish-config/cachyos-config.fish
```

**`~/.zshrc`** — remove:
```zsh
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
```

**`~/.config/fish/fish_variables`** — the `fish_user_paths` variable contains absolute paths (`/home/scottj/...`). Update them to match your new username/home on Ubuntu, or let Fish manage them fresh with `fish_add_path`.

## Post-install

```bash
# Fish plugins (fisher + nvm.fish)
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update'

# Rust toolchain (restores ~/.cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Node via nvm (config defaults to v24)
fish -c 'nvm install 24'

# Alacritty (not in Ubuntu repos by default)
sudo apt install cargo && cargo install alacritty
# or via PPA: https://github.com/alacritty/alacritty/blob/master/INSTALL.md

# GTK cursor theme used in configs
sudo apt install capitaine-cursors
```
