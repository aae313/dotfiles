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
    zoxide init fish | source

    abbr -a cp 'cp -rv'
    abbr -a mv 'mv -v'
    abbr -a rm 'rm -rvf'
    abbr -a mkdir 'mkdir -p'
    abbr -a cat bat
    abbr -a n hx
    abbr -a x hx
    abbr -a j just
    abbr -a calc numbat --pretty-print=always -e
    abbr -a xc chezmoi edit --verbose
    abbr -a py python
    abbr -a wl wl-copy
    abbr -a che chezmoi
    abbr -a apply chezmoi apply --verbose
    set -gx FZF_DEFAULT_OPTS "--highlight-line --cycle --layout=reverse --height=80% --bind=tab:down,btab:up,ctrl-space:toggle \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'

    if not set -q ZELLIJ; and test "$START_ZELLIJ" = 1
        set -e START_ZELLIJ
        zellij
    end
end
