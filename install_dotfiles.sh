#!/bin/sh

# THIS WILL NOT WORK
#
# .ph-my-zshrc/custom needs to go in on its own and if .oh-my-zshrc
# does not exist we need to install it

if [ ! -e ${HOME}/.oh-my-zshrc ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

DOTFILES="\
.aliases
.bash_profile
.bashrc
.gitattributes
.gitconfig
.gitignore
.inputrc
.osx
.tmux.conf
.vimrc
.zprofile
.zshenv
.zshrc
"

for filename in $DOTFILES
do
	ln -s $PWD/$filename ~
done

# now make symlinks for the dirs to be aliased, since these
# are somewhat one-off custom items do each individually

# .emacs.d
# .oh-my-zsh/custom
