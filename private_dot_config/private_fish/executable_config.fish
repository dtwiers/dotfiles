if status is-interactive
    starship init fish | source
    neofetch
    zoxide init fish | source
    source /home/derek/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
end

