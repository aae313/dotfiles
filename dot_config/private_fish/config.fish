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
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
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
