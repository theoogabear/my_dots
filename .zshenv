# zsh reads this for every invocation. Keep it cheap and side-effect free.
typeset -U path
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.bun/bin" "$HOME/go/bin" "$path[@]")
export PATH
