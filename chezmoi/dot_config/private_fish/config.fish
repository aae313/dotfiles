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
    set fish_key_bindings fish_vi_key_bindings
    fzf --fish | source
    starship init fish | source
    zoxide init fish --cmd cd | source

    abbr -a cp 'cp -rv'
    abbr -a mv 'mv -v'
    abbr -a rm 'rm -rvf'
    abbr -a mkdir 'mkdir -p'
    abbr -a cat bat
    abbr -a j just
    abbr -a za zellij action
    abbr -a calc numbat --pretty-print=always -e
    abbr -a py python
    abbr -a wl wl-copy
    abbr -a che chezmoi
    abbr -a xc chezmoi edit
    abbr -a apply chezmoi apply --verbose
    set -gx FZF_DEFAULT_OPTS "--highlight-line --cycle --layout=reverse --height=80% \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'

    if not set -q ZELLIJ; and test "$START_ZELLIJ" = 1
        set -e START_ZELLIJ
        zellij
    end
end
