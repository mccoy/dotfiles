# PATH should have been set in .zshenv
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# XXX: THIS IS A HACK
export PATH="/opt/homebrew/opt/kubernetes-cli@1.22/bin:$PATH"

# Setting GOPATH so that zsh plugin picks it up
export GOPATH=$HOME/go

# Path to your oh-my-zsh installation.
export ZSH="/Users/mccoy/.oh-my-zsh"

# Set name of the theme to load --- see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="crcandy"
if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
  ZSH_THEME="mccoyminimal"
else
  ZSH_THEME="mccoycandy"
fi

# Write perms are fixed but still complains, so disable this check
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(git brew history kubectl history-substring-search pyenv terraform vscode golang)

source $ZSH/oh-my-zsh.sh

# User configuration

# Trim path length in prompt
#PROMPT="%(4~|.../%3~|%~)"

# Colors.
#unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Update path
typeset -U path			# make path entries unique
path+=(~/bin $GOPATH/bin)	# append paths
#path=('~/bin' $path)		# prepend path element
export PATH

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# A fix for M1 macs
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Auros vault
export VAULT_ADDR='https://vault.auros.be'

# Aliases (the _local are for aliase local to this machine and not in my dotfiles repo)
#
# These are done as .alias files and not .oh-my-zsh/custom is because they are also bash aliaes
if [ -f $HOME/.aliases ]; then
   source ~/.aliases
fi
if [ -f $HOME/.aliases_local ]; then
  source ~/.aliases_local
fi

# Set homebrew vars
#[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

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
#Zsh substring history search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# GNUPG
#
export GPG_TTY=$(tty)
export GNUPGHOME=~/.gnupg

set term=xterm-256color
export TERM=xterm-256color
export LESS="-erX"
export BLOCKSIZE="1024"
export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8
export RSYNC_RSH=/usr/bin/ssh

# Umask bits.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi

# Completions.
# WARNING: the -u flag turns off legit security warnings too
autoload -Uz compinit && compinit -u
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

# iTerm2 integration
ITERM2_SQUELCH_MARK=1
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

iterm2_print_user_vars() {
  # aws profile
  AWSPROFILE=$(if [[ ! -v $AWS_PROFILE && ! -z $AWS_PROFILE ]];then echo "☁️ $AWS_PROFILE";fi)
  iterm2_set_user_var awsProfile $AWSPROFILE
  # kubernetes context
  KUBECONTEXT=$(CTX=$(kubectl config current-context) 2> /dev/null;if [ $? -eq 0 ]; then echo $CTX;fi)
  iterm2_set_user_var kubeContext $KUBECONTEXT
  iterm2_set_user_var currentPyenv "🐍$(pyenv_prompt_info)"
}

