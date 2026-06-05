function cat --wraps bat --description 'Alias for bat --paging=never'
    command bat --paging=never $argv
end