if status is-interactive
    starship init fish | source
    neofetch
    zoxide init fish | source
end

direnv hook fish | source
