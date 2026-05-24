function git_push
    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "git_push: not inside a Git repo" >&2
        return 1
    end

    command git add --all

    if command git diff --cached --quiet
        echo "git_push: no changes to commit" >&2
        return 1
    end

    set -l timestamp (date '+%a %b %-d %H:%M:%S %Z %Y')
    command git commit -m "$timestamp"
    and command git push
end
