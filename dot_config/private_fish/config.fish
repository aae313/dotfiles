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
    zoxide init fish --cmd cd | source
end

set -gx SUDO_EDITOR 'env -u NVIM_LISTEN_ADDRESS nvim'

set -gx FZF_DEFAULT_OPTS "\
--highlight-line \
--cycle \
--layout=reverse \
--height 80% \
  --color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 \
  --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c \
  --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c \
  --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 \
  --color=query:#ffffff \
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
