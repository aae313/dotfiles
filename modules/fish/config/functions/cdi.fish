function cdi --description "Search directories with fzf and cd into the selected one"
    set -f search_root $argv[1]

    if test -z "$search_root"
        set search_root .
    else if not test -d "$search_root"
        echo "cdi: not a directory: $search_root" >&2
        return 1
    end

    set -f preview_cmd "ls -la --color=always {}"
    if command -sq eza
        set preview_cmd "eza --all --color=always --icons=always --group-directories-first --tree --level=2 {}"
    else if command -sq tree
        set preview_cmd "tree -a -C -L 2 {}"
    end

    fd --type directory --hidden --follow --exclude .git . -- "$search_root" \
        | fzf \
            --prompt="Directories> " \
            --query=(commandline) \
            --preview="$preview_cmd" \
            --preview-window="right:60%:wrap" \
        | read -l dir

    if test $status -eq 0
        cd -- "$dir"
    end
end
