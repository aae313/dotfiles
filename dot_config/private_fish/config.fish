if status is-interactive
    # set -gx ZELLIJ_AUTO_ATTACH true
    # if not set -q ZELLIJ
    #     if test "$ZELLIJ_AUTO_ATTACH" = true
    #         if test (pgrep -c footclient) -le 1
    #             zellij attach --create main
    #         end
    #     else
    #         zellij --session main
    #     end
    # end
    set fish_greeting ""
    set fish_key_bindings fish_vi_key_bindings
    starship init fish | source
    zoxide init fish >~/.config/fish/conf.d/zoxide_init.fish
end

set -gx SUDO_EDITOR 'env -u NVIM_LISTEN_ADDRESS nvim'

set -gx FZF_DEFAULT_OPTS "\
--highlight-line \
--cycle \
--layout=reverse \
--height 80% \
  --color=bg+:#283457 \
  --color=bg:#000000 \
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
abbr -a cp cp -rv
abbr -a rm rm -rvf
abbr -a che chezmoi

abbr -a n nv
abbr -a vim nv
abbr -a x nv
abbr -a j just
abbr -a py python
abbr -a wl wl-copy

abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'
