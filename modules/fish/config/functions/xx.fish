function xx --description 'Select files and open them with nv'
    argparse 'e=' -- $argv; or return

    set -l target $argv[1]
    set -q target[1]; or set target .

    if test -f "$target"
        nv "$target"
        return
    else if not test -d "$target"
        echo "xx: not a directory: $target" >&2
        return 1
    end

    set -l fd_args . "$target" --type file
    set -q _flag_e; and set -a fd_args --extension "$_flag_e"

    set -l selections (command fd $fd_args | command fzf --multi)
    test (count $selections) -gt 0; or return 1

    nv $selections
end
