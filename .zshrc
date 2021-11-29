#
# .zshrc
#
# @author Jeff Geerling
#

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Theme
ZSH_THEME="candy"

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Define special keys
key=(
    BackSpace  "${terminfo[kbs]}"
    Home       "${terminfo[khome]}"
    End        "${terminfo[kend]}"
    Insert     "${terminfo[kich1]}"
    Delete     "${terminfo[kdch1]}"
    Up         "${terminfo[kcuu1]}"
    Down       "${terminfo[kcud1]}"
    Left       "${terminfo[kcub1]}"
    Right      "${terminfo[kcuf1]}"
    PageUp     "${terminfo[kpp]}"
    PageDown   "${terminfo[knp]}"
)

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Enable plugins.
plugins=(git brew history kubectl history-substring-search pyenv vscode)

# Update path
typeset -U path			# make path entries unique
path+=(~/bin ~/go/bin)		# append paths
#path=('~/bin' $path)		# prepend path element
export PATH

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# A fix for M1 macs
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Include alias file (if present) containing aliases for ssh, etc.
#if [ -f ~/.aliases ]
#then
#  source ~/.aliases
#fi

# Auros vault
export VAULT_ADDR='https://vault.auros.be'

# Aliases (the _local are for aliase local to this machine and not in my dotfiles repo)
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.aliases_local ] && source ~/.aliases_local

# Set homebrew vars
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Set eternal history
export HISTFILE=~/.zsh_history    # set our history file location
export HISTFILESIZE=1000000000    # max is max of a longint, a billion is good enough
export HISTSIZE=1000000000        # max is max of a longint, a billion is good enough
setopt inc_append_history         # immediately write to history file
setopt hist_ignore_dups           # ignore duplicated commands history list
setopt hist_ignore_space          # ignore commands that start with space
setopt hist_verify                # show command with history expansion to user before running it
setopt hist_find_no_dups          # skip sequential dupes when searching through history
setopt hist_no_store              # do not store history command
# History search keys
#bindkey "$key[Up]" history-begining-search-forward
#bindkey "$key[Down]" history-beginning-search-backward
#bindkey "$key[Up]" history-substring-search-up
#bindkey "$key[Down]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# GNUPG
#
export GPG_TTY=$(tty)
export GNUPGHOME=~/.gnupg

set term=xterm-256color
export TERM=xterm-256color
export LESS="-erX"
export BLOCKSIZE="1024"
export LC_ALL="en_US.UTF-8"
export RSYNC_RSH=/usr/bin/ssh

# Umask bits.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Ask for confirmation when 'prod' is in a command string.
#prod_command_trap () {
#  if [[ $BASH_COMMAND == *prod* ]]
#  then
#    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
#    if [[ $REPLY =~ ^[Yy]$ ]]
#    then
#      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
#    else
#      echo -e "\nCommand was not run.\n"
#      return 1
#    fi
#  fi
#}
#shopt -s extdebug
#trap prod_command_trap DEBUG
