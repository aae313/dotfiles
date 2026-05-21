function _fzf_search_processes --description "Search all running processes. Replace the current token with the pid of the selected process."
    set -f --export SHELL (command --search fish)

    set -f ps_cmd (command -v ps || echo "ps")
    set -f ps_preview_fmt (string join ',' 'pid' 'ppid=PARENT' 'user' '%cpu' 'rss=RSS_IN_KB' 'start=START_TIME' 'command')
    set -f processes_selected (
        $ps_cmd -A -opid,command | \
        command fzf --multi \
            --prompt="Processes> " \
            --query (commandline --current-token) \
            --ansi \
            --header-lines=1 \
            --preview="$ps_cmd -o '$ps_preview_fmt' -p {1} || echo 'Cannot preview {1} because it exited.'" \
            --preview-window="bottom:4:wrap" \
            $fzf_processes_opts
    )
    set -f fzf_status $status

    if test $fzf_status -eq 0
        set -f pids_selected
        for process in $processes_selected
            set -f --append pids_selected (string match --regex --groups-only '^\s*([0-9]+)' -- $process)
        end

        commandline --current-token --replace -- (string join ' ' $pids_selected)
    end

    commandline --function repaint
end
