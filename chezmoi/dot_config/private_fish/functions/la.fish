function la --wraps eza --description 'List all files with eza (including hidden)'
    command eza -a --git --icons --color=auto --group-directories-first $argv
end