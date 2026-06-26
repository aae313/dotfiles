function start_zellij
    status is-interactive; or return

    if set -q ZELLIJ
        return
    end

    if test "$START_ZELLIJ" = 1
        exec zellij
    end
end
if status is-interactive

    set -g fish_greeting
    set -g fish_key_bindings fish_helix_key_bindings
    fish_helix_key_bindings
    fish_user_key_bindings
    fzf --fish | source
    starship init fish | source
    zoxide init fish --cmd cd | source

    abbr -a cp 'cp -rv'
    abbr -a mv 'mv -v'
    abbr -a rm 'rm -rvf'
    abbr -a mkdir 'mkdir -p'
    abbr -a j just
    abbr -a za zellij action
    abbr -a calc numbat --pretty-print=always -e
    abbr -a py python
    abbr -a wl wl-copy
    abbr -a che chezmoi
    abbr -a xc chezmoi edit --apply --verbose
    abbr -a apply chezmoi apply --verbose
    set -gx FZF_DEFAULT_OPTS "--multi --highlight-line --cycle --layout=reverse --height=80% \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --color=bg+:#2f447f,bg:#000000,spinner:#00d3d0,hl:#d0bc00 \
    --color=fg:#ffffff,header:#c6daff,info:#989898,pointer:#2fafff \
    --color=marker:#00d3d0,fg+:#ffffff,prompt:#2fafff,hl+:#d0bc00 \
    --color=selected-bg:#303030 \
    --color=border:#646464,label:#ffffff"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'

    if not set -q ZELLIJ; and test "$START_ZELLIJ" = 1
        set -e START_ZELLIJ
        zellij
    end
end
