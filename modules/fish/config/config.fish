if status is-interactive

    set -g fish_greeting
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings
    fish_user_key_bindings
    fzf --fish | source
    starship init fish | source
    zoxide init fish --cmd cd | source

    # Self-heal the kitty in_editor var: a rendered prompt proves nvim is not
    # in the foreground, so a crashed nvim cannot leave the lock maps stuck.
    # Must live here, not in functions/: event handlers are never autoloaded.
    function __clear_in_editor --on-event fish_prompt
        printf '\033]1337;SetUserVar=in_editor\007'
    end

    abbr -a cp 'cp -rv'
    abbr -a mv 'mv -v'
    abbr -a rm 'rm -rvf'
    abbr -a mkdir 'mkdir -p'
    abbr -a j just
    abbr -a calc numbat --pretty-print=always -e
    abbr -a py python
    abbr -a wl wl-copy
    set -gx FZF_DEFAULT_OPTS "--multi --highlight-line --cycle --layout=reverse --height=80% \
    --info=inline-right \
    --ansi \
    --color=bg+:#2f447f,bg:#000000,spinner:#00d3d0,hl:#d0bc00 \
    --color=fg:#ffffff,header:#c6daff,info:#989898,pointer:#2fafff \
    --color=marker:#00d3d0,fg+:#ffffff,prompt:#2fafff,hl+:#d0bc00 \
    --color=selected-bg:#303030 \
    --color=border:#646464,label:#ffffff"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
end
