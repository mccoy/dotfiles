# Source various definitions from other files
BASH_SOURCES=(/etc/bashrc
              ~/.other_bashrc)
for SOURCE_FILE in "${BASH_SOURCES[@]}"; do
    if [ -f $SOURCE_FILE ]; then
        . $SOURCE_FILE
    fi
done

# Functions to help manage paths.
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
    PROMPT="\W"

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
EMACSAPP=/Applications/Emacs.app/Contents/MacOS
# Changing this to favor terminal windows for now
#if [ -f $EMACSAPP/bin/emacsclient ]; then
#    export EDITOR="${EMACSAPP}/bin/emacsclient -t -a ${EMACSAPP}/Emacs"
#    alias et="${EMACSAPP}/bin/emacsclient -t -a ${EMACSAPP}/Emacs"
#    alias ew="${EMACSAPP}/bin/emacsclient -c -a ${EMACSAPP}/Emacs"
#    alias e="${EMACSAPP}/bin/emacsclient -n -c -a ${EMACSAPP}/Emacs"
#
# The following worked fine but am trying a new osx/emacs setup
#if [ -f $EMACSAPP/Emacs ]; then
#    export EDITOR="${EMACSAPP}/Emacs"
#    alias emacs="${EDITOR} -nw"
#    alias et="${EDITOR} -nw"
#    alias ew=${EDITOR}
#    alias e=${EDITOR}
#
if [ -f $EMACSAPP/Emacs ]; then
    alias emacsclient="${EMACSAPP}/bin/emacsclient"
    alias et="emacsclient -t -a ~/Applications/emacst"
    alias emacs="~/Applications/ec"
    export EDITOR="~/Applications/ec"
elif [ -f /usr/local/bin/emacs -a /usr/local/bin/emacsclient ]; then
    export EDITOR="/usr/local/bin/emacsclient -t -a /usr/local/bin/emacs"
    alias e=${EDITOR}
elif [ -f /usr/bin/emacs -a /usr/bin/emacsclient ]; then
    export EDITOR="/usr/bin/emacsclient -t -a /usr/bin/emacs"
    alias e=${EDITOR}
else
    export EDITOR=vi
    alias e=${EDITOR}
fi
alias et=${EDITOR}

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Programming/admin

alias edsac="ssh -A 162.248.11.170" 

function cheat() {
    curl cht.sh/$1
}

# Ansible
function ansiblePlaybookDebug {
    export ANSIBLE_STDOUT_CALLBACK=default
    echo -n "$@" | grep -q -- "-v" && export ANSIBLE_STDOUT_CALLBACK=yaml
    'ansible-playbook' "$@"
}
alias ansible-playbook='ansiblePlaybookDebug'

# Go
export GOPATH=${HOME}/Documents/code/go:/usr/local/Cellar/go/1.2.1/libexec/bin
if [ -d ${GOPATH}/bin ] ; then
    export PATH=${PATH}:${GOPATH}/bin
fi

# Python
if [ -f ~/.pythonrc ]; then
    export PYTHONSTARTUP=~/.pythonrc
fi
# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
# find outdated pip packages
alias pip-outdated='pip freeze | cut -d = -f 1 | xargs -n 1 pip search | grep -B2 "LATEST:"'
alias pip-upgrade-all='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'

# Erlang
export ERL_FLAGS="-smp auto +K true"
export ERL_LIBS="/usr/local/lib/erlang/lib"

# Haskell
#
if [ -e ${HOME}/Library/Haskell/bin ]; then
    export PATH=${PATH}:${HOME}/Library/Haskell/bin:${HOME}/.cabal/bin
fi

# Node
#
export NODE_PATH=/usr/local/lib/node_modules

# remote desktop ssh tunnel
alias ardtunnel="ssh -L3283:127.0.0.1:3283 -L5901:127.0.0.1:5900"

# Homebrew
if [ -f /usr/local/bin/brew ]; then
    # bach_competion for homebrew packages
    if [ -f `brew --prefix`/etc/bash_completion ]; then
      . `brew --prefix`/etc/bash_completion
    fi
    # autojump
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi
# put homebrew cask bits in /usr/local instead of /opt
#export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/usr/local/Caskroom"

brew-cask-upgrade() { 
  if [ "$1" != '--continue' ]; then 
    echo "Removing brew cache" 
    rm -rf "$(brew --cache)" 
    echo "Running brew update" 
    brew update 
  fi 
  for c in $(brew cask list); do 
    echo -e "\n\nInstalled versions of $c: " 
    ls /opt/homebrew-cask/Caskroom/$c 
    echo "Cask info for $c" 
    brew cask info $c 
    select ynx in "Yes" "No" "Exit"; do  
      case $ynx in 
        "Yes") echo "Uninstalling $c"; brew cask uninstall --force "$c"; echo "Re-installing $c"; brew cask install "$c"; break;; 
        "No") echo "Skipping $c"; break;; 
        "Exit") echo "Exiting brew-cask-upgrade"; return;; 
      esac 
    done 
  done 
} 

# tmuxinator bash completion
if [ -f ~/.tmux.completion ]; then
    . ~/.tmux.completion
fi

# Misc aliases
alias lsd="ls -l | grep ^d"
alias bookpush="rsync -vaz --del /Volumes/Acyclic/Books/ bombe.mad-scientist.com:/Volumes/Media/Books/"
alias altbookpush="rsync -vaz --del /Volumes/Acyclic/Books-Alt/ bombe.mad-scientist.com:/Users/mccoy/Documents/Books-Alt/"

# Blog aliases
alias blogdir="cd /Volumes/Acyclic/Documents/blog"
alias blogpush="(cd /Volumes/Acyclic/Documents/blog ; rake deploy)"
alias codedir="cd /Volumes/Acyclic/Documents/code"
alias erldir="cd /Volumes/Acyclic/Documents/code/erlang"


# On OS X this will cd to the top-most Finder window
cdfinder() {
  cd "$( /usr/bin/osascript <<"    EOT"
    tell application "Finder"
      try
        set currFolder to (folder of the front window as alias)
      on error
        set currFolder to (path to home folder as alias)
      end try
      POSIX path of currFolder
    end tell
    EOT
    )"
}

# Used as a drop-in replacement for grep that colors matching lines, but prints all lines
function highlight() {
  local args=( "$@" )
  for (( i=0; i<${#args[@]}; i++ )); do
    if [ "${args[$i]:0:1}" != "-" ]; then
      args[$i]="(${args[$i]})|$"
      break
    fi
  done
  grep --color -E "${args[@]}"
}

# greps()
# {
#    grep -nr "${@}" ` find $SRC/amdlib/ $SRC/ui/ $SRC/build/ $SRC/tests/ -name '*.py' ` | sed -e "s%^[^:]*$SRC/%%"
# }
# grepall()
# {
#     grep -nr "${@}" $SRC | grep -v \\.svn | grep '\.py:' | sed -e "s%^[^:]*$SRC/%%"
# }

function localalias() {
  ipaddr=`dig +short $2`
  sudo dscl localhost -create /Local/Defaults/Hosts/$1 IPAddress $ipaddr
  dscacheutil -flushcache
}

function delalias() {
  sudo dscl localhost -delete /Local/Default/Hosts/$1
}

function lsalias() {
  sudo dscl localhost -list /Local/Default/Hosts IPAddress
}

function dnsflush() {
  sudo dscacheutil -flushcache >& /dev/null
  sudo killall -HUP mDNSResponder >& /dev/null
  # dnslauncher is what HandsOff uses to wrap dns lookups...
  sudo killall -HUP dnslauncher >& /dev/null
}

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# zoxide
eval "$(zoxide init bash)"

#eval "$(starship init bash)"
