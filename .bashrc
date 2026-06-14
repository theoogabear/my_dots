# Interactive bash configuration.
[[ $- != *i* ]] && return

[ -r "$HOME/.shenv" ] && . "$HOME/.shenv"
[ -r "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
fi

venv() {
    if [ -r .venv/bin/activate ]; then
        . .venv/bin/activate
    elif [ -r "$HOME/adk-env/bin/activate" ]; then
        . "$HOME/adk-env/bin/activate"
    else
        echo "No venv found" >&2
        return 1
    fi
}

PS1='[\u@\h \W]\$ '

if [ -t 1 ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
