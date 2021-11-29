# .zshenv
#
# Every zsh instance (interactive and non-interactive) runs this

# Set basic PATH
export PATH=/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Need to set pyenv bits very early
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

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
