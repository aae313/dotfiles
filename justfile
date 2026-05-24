set shell := ["fish", "-c"]

switch:
    #!/usr/bin/env fish

    set -l log (mktemp)
    trap "rm -f $log" EXIT

    nh os switch 2>&1 | tee "$log"
    set -l code $pipestatus[1]

    if test "$code" -ne 0
        bat --paging never --plain "$log"
        exit "$code"
    end

boot:
    nh os boot -- --impure

repair:
    nix-store --verify --check-contents --repair

curgen:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

up:
    nix flake update
    nh os switch -- --impure

history:
    nix profile history --profile /nix/var/nix/profiles/system

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system

gc:
    sudo nix-collect-garbage
    nix-collect-garbage

gitgc:
    git reflog expire --expire-unreachable=now --all
    git gc --prune=now

chezmoi:
    chezmoi init --apply --ssh git@github.com:aae313/dotfiles.git

push:
    set -l timestamp (date "+%Y-%m-%d %H:%M:%S"); read --prompt-str "Details: " extra; set -l extra (string trim -- "$extra"); set -l message; if test -z "$extra"; set message "$timestamp"; else; set message "$timestamp: $extra"; end; jj describe --message "$message"; and jj bookmark move main --to @; and jj git push --bookmark main
