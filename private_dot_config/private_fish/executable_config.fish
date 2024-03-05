if status is-interactive
    starship init fish | source
    neofetch
    zoxide init fish | source
    if test -z "$ASDF_HOME" -o ! -f "$ASDF_HOME"
        echo "Error: \$ASDF_HOME is not set or does not point to a valid file."
    end
end
source $ASDF_HOME
