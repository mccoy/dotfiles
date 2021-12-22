# .zprofile
#
# Every zsh login shell runs this once

# Set basic PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Set homebrew vars
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Need to set pyenv bits very early
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# Set ssh-agent
ssh-add -l >/dev/null

#if [ $? == 2 ] ; then
#   # No agent was forwarded, now it's safe to set one up
#   mkdir -p ~/.ssh/agent-state
#
#   SSHPROFILE=~/.ssh/agent-state/${HOSTNAME}
#
#   # Try to attach to a currently running agent
#   if [ -e "$SSHPROFILE" ] ; then
#      . "$SSHPROFILE" > /dev/null
#   fi
#
#   # Make sure we succeeded
#   ssh-add -l >/dev/null
#   if [ $? == 2 ] ; then
#      echo "starting ssh-agent"
#      ssh-agent -s > "$SSHPROFILE"
#      .  "$SSHPROFILE" > /dev/null
#
#      echo "NOTE: New agent started, you should add your keys with 'ssh-add'!"
#   fi
#fi
