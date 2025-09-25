if status is-interactive
    starship init fish | source
    fastfetch || neofetch
    zoxide init fish | source
    fzf --fish | source
    if type -q 'mise'
        mise activate fish | source
    end
end

abbr --add gils eza --long --git --header --git-ignore --git-repos
abbr --add ll eza --long --git --header --almost-all --git-repos


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r "~/.opam/opam-init/init.fish" && source "~/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
if type -q 'opam'
    eval (opam env)
end
# END opam configuration

if test -r "./private.fish"
    source "./private.fish"
end
