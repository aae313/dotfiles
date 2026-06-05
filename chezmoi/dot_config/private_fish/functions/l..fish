function l. --wraps eza --description 'List only dotfiles in the current directory'
    command eza -a $argv | command rg '^\.'
end