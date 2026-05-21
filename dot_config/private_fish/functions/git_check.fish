function git_check
    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "git_check: not inside a Git repo" >&2
        return 1
    end

    echo "Repo: "(basename (command git rev-parse --show-toplevel))
    echo "Path: "(command git rev-parse --show-toplevel)
    echo "Branch: "(command git branch --show-current)

    echo
    echo "Remotes:"
    command git remote -v

    echo
    echo "Status:"
    command git status --short
end
