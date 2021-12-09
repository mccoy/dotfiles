# Source various definitions from other files
BASH_SOURCES=(/etc/bashrc
              ~/.other_bashrc)
for SOURCE_FILE in "${BASH_SOURCES[@]}"; do
    if [ -f $SOURCE_FILE ]; then
        . $SOURCE_FILE
    fi
done

# Functions to help manage paths, basically a few funcs to emulate zsh path adding/removing
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

# User specific environment and startup programs
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
PREPATH=($HOME/bin /opt/homebrew/bin \
         /usr/local/bin /usr/local/sbin)
POSTPATH=(/usr/local/share/npm/bin \
          /usr/local/lib/elixir/bin \
          $HOME/go/bin \
          $HOME/.local/bin \
          $HOME/Applications) 
# reverse PREPATH since we will be repeatedly prepending
PREPATH=( $(echo ${PREPATH[@]} | awk '{for (i=NF;i>=1;i--) printf $i" "} END{print ""}') )

for PATH_ELEM in "${PREPATH[@]}"; do
    if [ -d $PATH_ELEM ]; then
        pathprepend $PATH_ELEM
    fi
done

for PATH_ELEM in "${POSTPATH[@]}"; do
    if [ -d $PATH_ELEM ]; then
        pathappend $PATH_ELEM
    fi
done

# Cleanup
unset pathappend pathremove pathprepend

# Early bail-out for non-interactive sessions
[[ ${-#*i} != ${-} ]] || return


# Aliases (the _local are for aliase local to this machine and not in my dotfiles repo)
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.aliases_local ] && source ~/.aliases_local

# vagrant alias
#alias setvopts="export VOPTS=`vagrant ssh-config | grep -v '^Host ' | awk -v ORS=' ' 'NF{print \"-o \" $1 \"=\" $2}'`"

# Kill xon/xoff
stty -ixon

# Colors for terminal
#  (should really check to see if $TERM contains "color"...)
export CLICOLOR=1

# Prompt and terminal app title
#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
#export PS1="[\u@\h \W\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1}/')]\\$ "

# Old prompt attempts
#
# Trying to turn $/# red if previous exit code was not 0
#export PROMPT_COMMAND='if [ $? = 0 ]; then DOLLAR_COLOR="\033[0m"; else DOLLAR_COLOR="\033[31m"; fi ; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
#export PS1="[\u@\h \W\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1}/')]\\[$(echo -ne $DOLLAR_COLOR)\\]\\$\\[\\033[m\\] "
#export PS1="[\h \W]\\$ "

function updatePrompt {
    # Set iterm2 title
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"

    # Styles
    GREEN='\[\e[0;32m\]'
    BLUE='\[\e[0;34m\]'
    RED='\[\e[0;31m\]'
    RESET='\[\e[0m\]'

    # Base prompt: \W = working dir
    PROMPT="[\u@\h:\w]"

    # Current Git repo
    if type "__git_ps1" > /dev/null 2>&1; then
        PROMPT="$PROMPT$(__git_ps1 "${GREEN}(%s)${RESET}")"
    fi

    # Current virtualenv
    if [[ $VIRTUAL_ENV != "" ]]; then
        # Strip out the path and just leave the env name
        PROMPT="$PROMPT${RED}{${VIRTUAL_ENV##*/}}${RESET}"
    fi

    PS1="$PROMPT \\$ "
}
export -f updatePrompt

# Bash shell executes this function just before displaying the PS1 variable
export PROMPT_COMMAND='updatePrompt'

# Promopt for eternal history
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo "$(history 1 | sed "s, *[0-9][0-9]* *,," )" >> ~/.bash_eternal_history' 

shopt -s checkwinsize

# A fix for M1 macs
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# GNUPG
#
export GPG_TTY=$(tty)
export GNUPGHOME=~/.gnupg

# Eternal bash history.
# see http://stackoverflow.com/questions/9457233/unlimited-bash-history
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTIGNORE="&:[bf]g:ls:exit"
export HISTCONTROL=erasedups
export HISTTIMEFORMAT="[%F %T] "
shopt -s histappend
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

set term=xterm-256color
export TERM=xterm-256color
export BLOCKSIZE="1024"
IGNOREEOF=1  # number of extra consecutive eof's to exit a shell
export LC_ALL="en_US.UTF-8"
export RSYNC_RSH=/usr/bin/ssh
export MANPATH=/opt/local/share/man:/usr/local/share/man:/usr/bin/man:/usr/local/man:/usr/share/man:${MANPATH}

# Umask bits.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi

# Editing/paging
export LESS="-erX"
export ALTERNATE_EDITOR=""

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Programming/admin

alias edsac="ssh -A 162.248.11.170" 

# Go
export GOPATH=${HOME}/Documents/code/go:/usr/local/Cellar/go/1.2.1/libexec/bin
if [ -d ${GOPATH}/bin ] ; then
    export PATH=${PATH}:${GOPATH}/bin
fi

# Python
if [ -f ~/.pythonrc ]; then
    export PYTHONSTARTUP=~/.pythonrc
fi

# Erlang
export ERL_FLAGS="-smp auto +K true"
export ERL_LIBS="/usr/local/lib/erlang/lib"

# Node
#
export NODE_PATH=/usr/local/lib/node_modules

# remote desktop ssh tunnel
alias ardtunnel="ssh -L3283:127.0.0.1:3283 -L5901:127.0.0.1:5900"

# Homebrew
if [ -f /usr/local/bin/brew ] || [ -f /opt/homebrew/bin/brew ]; then
    # bach_competion for homebrew packages
    if [ -f `brew --prefix`/etc/bash_completion ]; then
      . `brew --prefix`/etc/bash_completion
    fi
    # autojump
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi

# tmuxinator bash completion
if [ -f ~/.tmux.completion ]; then
    . ~/.tmux.completion
fi

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# zoxide
#eval "$(zoxide init bash)"
