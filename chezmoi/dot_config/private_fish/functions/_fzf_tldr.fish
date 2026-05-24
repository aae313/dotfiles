function _fzf_tldr --description "Search tldr using fzf"
    fd --print0 --extension md . ~/.cache/tealdeer/tldr-pages/pages/{linux,common} \
        | sed -z 's/.*\///; s/\.md$//' \
        | command fzf --read0 --query=(commandline) --preview 'fish -c "tldr {}"' --preview-window right:75% \
        | read -lz cmd

    if test $status -eq 0
        tldr (string trim $cmd)
    end
end
