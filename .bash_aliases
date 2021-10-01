# Bash aliases

alias mosh="perl -E ' print \"\e[?1005h\e[?1002h\" ' && mosh"
alias sshcheck="openssl s_client -connect"
alias x509="openssl x509 -noout -text -in"
alias whatsmyip="wget http://ipecho.net/plain -O - -q ; echo"
alias rgrep="grep -R"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias lsd="ls -l | grep ^d"

