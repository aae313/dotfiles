function ls --wraps eza --description 'List files with eza (common options)'
    command eza -h --git --icons --color=auto --group-directories-first -s extension $argv
end