source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end


# Added by Antigravity CLI installer
set -gx PATH "/home/scottj/.local/bin" $PATH
function venv --description "Activate nearest Python venv"
    if test -e .venv/bin/activate.fish
        source .venv/bin/activate.fish
    else if test -e ~/adk-env/bin/activate.fish
        source ~/adk-env/bin/activate.fish
    else
        echo "No venv found"
    end
end
