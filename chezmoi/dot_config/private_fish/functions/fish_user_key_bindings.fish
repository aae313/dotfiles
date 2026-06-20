function fish_user_key_bindings
    bind -M default ' f' fzf-cd-widget
    bind -M default ' h' fzf-history-widget
    bind -M default ' w' "zellij action switch-mode pane"
    bind -M default ' t' "zellij action switch-mode tab"
    bind -M default ' s' "zellij action switch-mode scroll"
    bind -M default ' r' "zellij action switch-mode resize"
end
