function backup -a filename
    if test -z "$filename"
        echo "backup: missing file" >&2
        return 1
    end
    mv -n -- "$filename" "$filename.bak"
end
