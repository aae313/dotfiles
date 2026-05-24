if status is-interactive

    set -gx ZELLIJ_AUTO_ATTACH true
    if not set -q ZELLIJ
        if test "$ZELLIJ_AUTO_ATTACH" = true
            if test (pgrep -c footclient) -le 1
                zellij attach --create main
            end
        else
            zellij --session main
        end
    end

    set -g fish_greeting
    set fish_key_bindings fish_vi_key_bindings
    fzf --fish | source
    starship init fish | source
    zoxide init fish | source

    abbr -a cp 'cp -rv'
    abbr -a mv 'mv -v'
    abbr -a rm 'rm -rvf'
    abbr -a mkdir 'mkdir -p'
    abbr -a cat bat
    abbr -a n nv
    abbr -a x nv
    abbr -a j just
    abbr -a calc numbat --pretty-print=always -e
    abbr -a xc chezmoi edit --verbose
    abbr -a py python
    abbr -a wl wl-copy
    abbr -a che chezmoi
    abbr -a apply chezmoi apply --verbose
    set -gx FZF_DEFAULT_OPTS "--highlight-line --cycle --layout=reverse --height=80% --bind=tab:down,btab:up,ctrl-space:toggle"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'

    bind tab fzf_complete
    bind -M insert tab fzf_complete
    bind -M default tab fzf_complete
end
