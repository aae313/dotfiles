function user_services
    set_color cyan
    echo "=== Running user services ==="
    set_color normal
    systemctl --user --type=service --state=running
    echo
    set_color yellow
    echo "=== Running user scopes ==="
    set_color normal
    systemctl --user --type=scope --state=running
end
