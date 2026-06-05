function clip
    if test (count $argv) -eq 0
        echo "clip: missing file" >&2
        return 1
    end

    set -f files
    for f in $argv
        if test -f "$f"
            set --append files "$f"
        end
    end

    if test (count $files) -eq 0
        echo "clip: no regular files" >&2
        return 1
    end

    for f in $files
        echo "== file: "(realpath -- "$f")" =="
        command cat -- "$f"
    end | wl-copy
end
