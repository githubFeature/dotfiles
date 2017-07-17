# If not running interactively, don't do anything
if [[ -z "$PS1--" ]]; then
    exit
fi

set +o histexpand

# stop on errors
#set -euo pipefail

# split words on this chars only (useful for ``for``)
#IFS=$'\n\t'

export EDITOR=editor
export LESS="WR"
export LV="-c"

# virtualenv wrapper
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# user completions
if [[ -d "$HOME/.bash_completion.d" ]]; then
    for a in $HOME/.bash_completion.d/*; do
        source "$a"
    done
    unset a
fi

if [[ -d "$HOME/.local/etc/bash_completion.d" ]]; then
    for a in $HOME/.local/etc/bash_completion.d/*; do
        source "$a"
    done
    unset a
fi

# Alias definitions.
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# enable programmable completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

STACK_BINARY=$(which stack)
if [[ ! -z $STACK_BINARY ]]; then
    eval "$(stack --bash-completion-script $STACK_BINARY)"
fi
unset STACK_BINARY

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# add cmd to history immediately after execution
PROMPT_COMMAND="history -a;history -n"

# don`t add to history matching cmds
HISTIGNORE="&:ls:ll:bg:fg:exit:history:ranger:off:q[q0-9]:=[0-9]:clear:encfs*:visit_efs*"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi

if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ "$color_prompt" = yes ]]; then
    if [[ -f ~/.bash_prompt ]]; then
        source ~/.bash_prompt
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[04;34m\]\u@\h\[\033[00m\]:\[\033[02;33m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    LS_COLORS="$LS_COLORS*.ipynb=02;36:*.py=02;36:*.clj=02;36:*.hs=03;36:*.lhs=03;36:*.purs=03;36:*.elm=03;36:"
fi

# build-deps cleanup
# http://www.webupd8.org/2010/10/undo-apt-get-build-dep-remove-build.html
function aptitude-remove-dep() {
    sudo aptitude markauto $(apt-cache showsrc "$1" | grep Build-Depends | perl -p -e 's/(?:[\[(].+?[\])]|Build-Depends:|,|\|)//g');
}

visit_efs() {
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

radio() {
    mpv --no-video --audio-display=no --playlist=$HOME/Dropbox/tux_cfg/mpd_playlists/"`ls -1 $HOME/Dropbox/tux_cfg/mpd_playlists/ | percol`"
}

ghcidf () {
    if [[ -z "$1" ]]; then
        echo "Usage: ghcidf <file.[l]hs> [<ghcid-flags>]"
    else
       ghcid $2 $3 $4 $5 -c "stack exec -- ghci" --test "main" $1
    fi
}
