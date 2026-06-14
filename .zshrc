# Interactive zsh configuration.
[[ -o interactive ]] || return

# Keep distro-provided defaults when this repo is used on CachyOS; skip elsewhere.
[[ -t 1 && -r /usr/share/cachyos-zsh-config/cachyos-config.zsh ]] && source /usr/share/cachyos-zsh-config/cachyos-config.zsh

bindkey -e
bindkey '^U' backward-kill-line
bindkey '^Y' yank

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=*'
zstyle ':completion:*' squeeze-slashes true

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
export TERM="${TERM:-xterm-256color}"

typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
    "$HOME/go/bin"
    "$HOME/adk-env/bin"
    "$path[@]"
)

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -r "$HOME/.secrets" ]] && source "$HOME/.secrets"

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

GPG_TTY=$(tty)
export GPG_TTY

venv() {
    if [[ -r .venv/bin/activate ]]; then
        source .venv/bin/activate
    elif [[ -r "$HOME/adk-env/bin/activate" ]]; then
        source "$HOME/adk-env/bin/activate"
    else
        echo "No venv found" >&2
        return 1
    fi
}

if [[ -t 1 ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
