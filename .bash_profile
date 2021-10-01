# .bash_profile
# Set ssh-agent
ssh-add -l >/dev/null

if [ $? == 2 ] ; then
   # No agent was forwarded, now it's safe to set one up
   mkdir -p ~/.ssh/agent-state

   SSHPROFILE=~/.ssh/agent-state/${HOSTNAME}

   # Try to attach to a currently running agent
   if [ -e "$SSHPROFILE" ] ; then
      . "$SSHPROFILE" > /dev/null
   fi

   # Make sure we succeeded
   ssh-add -l >/dev/null
   if [ $? == 2 ] ; then
      echo "starting ssh-agent"
      ssh-agent -s > "$SSHPROFILE"
      .  "$SSHPROFILE" > /dev/null

      echo "NOTE: New agent started, you should add your keys with 'ssh-add'!"
   fi
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

