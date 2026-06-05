function lt --wraps eza --description 'List files with eza (tree view, level 2)'
    command eza -T --git --icons --color=auto --level=2 --group-directories-first $argv
end