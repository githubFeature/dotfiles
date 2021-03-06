#!/bin/bash

# some more ls aliases
alias ls='/bin/ls -Fv --color=auto'
alias ll='/bin/ls -FvlGh --color=auto --time-style=long-iso --group-directories-first'
alias la='/bin/ls -FvA --color=auto'
alias l='/bin/ls -af1v'

alias playlist-dl="youtube-dl -o '~/Downloads/youtube/%(uploader)s/%(playlist_mb_title)s/%(playlist_index)s. %(title)s.%(ext)s'"

alias e="emacs"
alias ec="emacsclient -nq"
alias eq="emacs -Q"
alias enq="emacs -Q -nw"

path() {
    echo -e "${PATH//:/\\n}"
}

alias grep="grep --color=auto"

alias cat="bat"

cal() {
    ncal -bM ${1:--3}
}

gostack() {
    env PATH=$(stack path --compiler-tools-bin):$PATH debian_chroot=$debian_chroot${debian_chroot:+,}stacked bash
}

goprivoxy() {
    env HTTPS_PROXY=127.0.0.1:8118 debian_chroot=$debian_chroot${debian_chroot:+,}proxied bash
}

mcd () {
    mkdir -p -- "$*" && builtin cd -- "$*"
}

timestamp () {
    date +%Y%m%d_%H%M%S;
}

gotempdir () {
    local DIR=/tmp/$(timestamp)
    if [[ ! -a "$DIR" ]]; then
        read -n 1 -p "Folder \"$DIR\" will be created..."
        mkdir -p -- "$DIR" && builtin cd -- "$DIR"
    fi
}

visit_efs () {
    if [[ -z "$1" ]]; then
        echo "Usage: cmd src [dest]"
    else
        if [[ -z "$2" ]]; then
            local dest="/tmp/decrypted"
        else
            local dest="$2"
        fi
        if [[ ! -d "$dest" ]]; then
            mkdir $dest
        fi
        encfs "$1" $dest && ranger $dest && fusermount -u $dest
    fi
}

gominimalprompt () {
    export MINIMAL_PROMPT=1
    bash
}

# jupms
# source: https://www.datascienceworkshops.com/blog/quickly-navigate-your-filesystem-from-the-command-line/
export MARKPATH=$HOME/.marks

j () {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark () {
    if [[ ! -d "$MARKPATH" ]]; then
        mkdir -p "$MARKPATH"
    fi
    ln -s "$(pwd)" "$MARKPATH/$1"
}

unmark () {
    rm -i "$MARKPATH/$1"
}

marks () {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks () {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find $MARKPATH -type l -printf "%f\n")
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

complete -F _completemarks j unmark
