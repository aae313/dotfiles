function xrg
    if test (count $argv) -eq 0
        echo "xrg: missing search pattern" >&2
        return 1
    end

    set -f file (command rg --files-with-matches -- $argv | command fzf --exit-0 --preview 'bat --style=numbers --color=always {}')
    test -n "$file"; or return
    hx $file
end
