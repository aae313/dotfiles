function ll --wraps eza --description 'List files with eza (long format)'
    command eza -l --git --icons --color=auto --group-directories-first $argv
end