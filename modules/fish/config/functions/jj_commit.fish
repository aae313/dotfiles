function jj_commit
    set -l timestamp (date '+%Y-%m-%d %H:%M')
    set -l extra
    read --prompt-str "Details: " extra
    set extra (string trim -- "$extra")
    set -l message

    if test -z "$extra"
        set message "$timestamp"
    else
        set message "$timestamp: $extra"
    end

    jj --no-pager commit --message "$message"
    and jj --no-pager bookmark move main --to @-
end
