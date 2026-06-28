function restore -a file
    if test -z "$file"
        echo "restore: missing file" >&2
        return 1
    end
    set original (string replace -r '\.bak$' '' -- "$file")
    if test "$original" = "$file"
        echo "restore: not a .bak file: $file" >&2
        return 1
    end
    mv -n -- "$file" "$original"
end
