function fbat
    if test (count $argv) -eq 0
        echo "fbat: missing file search pattern" >&2
        return 1
    end

    set -l files (command fd --type f --color=never -- $argv)
    set -l file_count (count $files)

    if test $file_count -eq 0
        echo "fbat: no matching files" >&2
        return 1
    end

    if test $file_count -eq 1
        command bat -- $files[1]
        return $status
    end

    set -l file (printf '%s\n' $files | command fzf --exit-0 --preview 'bat --style=numbers --color=always -- {}')
    test -n "$file"; or return

    command bat -- $file
end
