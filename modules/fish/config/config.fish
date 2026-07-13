if status is-interactive

    source $__fish_config_dir/themes/modus.theme

    set -g fish_greeting
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings
    fish_user_key_bindings

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
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'

    if not set -q ZELLIJ; and test "$START_ZELLIJ" = 1
        set -e START_ZELLIJ
        zellij
    end
end
