if status is-interactive

    set fish_greeting ""
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
    set -gx FZF_DEFAULT_OPTS "--highlight-line --cycle --layout=reverse --height=80%"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
end

set -gx EDITOR nv
set -gx VISUAL nv
set -gx SUDO_EDITOR 'env -u NVIM_LISTEN_ADDRESS nvim'
set -gx PAGER 'bat --style=plain --paging always'
set -gx BAT_PAGER 'ov -F -H3'
set -gx MANPAGER "ov --section-delimiter '^[^\s]' --section-header"
set -gx MANROFFOPT -c
set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc
set -gx DIRENV_LOG_FORMAT ''
set -gx NIX_AUTO_RUN 1


if status is-login; and command -q systemctl
    systemctl --user show-environment | while read -l line
        set -l kv (string split -m 1 = -- $line)
        if test $kv[1] = PATH
            set -gx PATH (string split : -- $kv[2])
        else
            set -gx $kv[1] $kv[2]
        end
    end
end
