# Interactive fish configuration.

if test -r /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

fish_add_path --path \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.bun/bin \
    $HOME/go/bin \
    $HOME/adk-env/bin

set -gx EDITOR (set -q EDITOR; and echo $EDITOR; or echo nvim)
set -gx VISUAL (set -q VISUAL; and echo $VISUAL; or echo $EDITOR)

if test -r $HOME/.secrets.fish
    source $HOME/.secrets.fish
end

if status is-interactive
    if command -q starship
        starship init fish | source
    end
end

function venv --description "Activate nearest Python venv"
    if test -e .venv/bin/activate.fish
        source .venv/bin/activate.fish
    else if test -e $HOME/adk-env/bin/activate.fish
        source $HOME/adk-env/bin/activate.fish
    else
        echo "No venv found" >&2
        return 1
    end
end
