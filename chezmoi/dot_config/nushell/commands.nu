export alias l = ls
export alias la = ls --all
export alias ll = ls --long
export alias lla = ls --long --all
export alias cp = cp --recursive --verbose
export alias mv = mv --verbose
export alias rm = rm --recursive --verbose --force --trash
export alias cat = bat
export alias j = just
export alias calc = numbat --pretty-print=always -e
export alias xc = chezmoi edit --apply
export alias py = python
export alias wl = wl-copy
export alias che = chezmoi
export alias apply = chezmoi apply

export def _ []: nothing -> any { $env.last? }

export def --env mc [path: path]: nothing -> nothing {
    mkdir $path
    cd $path
}

export def --env mcg [path: path]: nothing -> nothing {
    mkdir $path
    cd $path
    jj git init
}

export def jjc []: nothing -> nothing {
    let timestamp = date now | format date "%Y-%m-%d %H:%M"
    let extra = input "Details: " | str trim
    let message = if ($extra | is-empty) {
        $timestamp
    } else {
        $"($timestamp): ($extra)"
    }

    jj --no-pager commit --message $message
    if $env.LAST_EXIT_CODE == 0 {
        jj --no-pager bookmark move main --to @-
    }
}
