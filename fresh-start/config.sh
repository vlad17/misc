#!/bin/bash
#
# Preps my environment. Does not rely on sudo (downloads, compiles locally).
# Sets up git config, emacs config, and bash config. Presumes all of these
# (and hopefully clang) have already been installed.

set -e
set -x

FRESH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $FRESH_DIR

if ! [ -f $HOME/.bashrc ]; then
    echo "weird, you don't have a ~/.bashrc, making one (do check it)"
    cp unmaintained/.bashrc $HOME
fi

if ! [ -f $HOME/.bashrc ]; then
    echo "weird, you don't have a ~/.bash_profile, making one (do check it)"
    cp unmaintained/.bash_profile $HOME
else
    echo 'checking you source .bashrc in .bash_profile'
    [ -f .bash_profile ] && grep '.bashrc' .bash_profile
fi

echo 'adding .bash_defs to .bashrc'
printf '\n# My personal definitions\nsource $HOME/.bash_defs' >> $HOME/.bashrc

echo "copying over .bash_defs, .tmux.conf"
if [ -f $HOME/.bash_defs ] ; then
    mv $HOME/.bash_defs $HOME/.bash_defs.old
fi
if [ -f $HOME/.tmux.conf ] ; then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.old
fi

cp .bash_defs $HOME
cp .tmux.conf $HOME

mkdir -p $HOME/bin
cp bin/* $HOME/bin

echo "installing .commacd.bash"
curl -sSL https://github.com/shyiko/commacd/raw/v1.0.0/commacd.sh -o ~/.commacd.bash

if ! which git; then
    echo "No git!"
fi

git config --global user.name "Vladimir Feinberg"
git config --global user.email "vladimir.feinberg@gmail.com"
git config --global alias.exec '!exec '
git config --global push.default simple

echo '#!/bin/bash

emacs -Q --no-window-system $@
' > ~/bin/emerge-for-git
chmod 755 ~/bin/emerge-for-git 
git config --global mergetool.emerge.path $HOME/bin/emerge-for-git
git config --global merge.tool emerge
git config --global core.editor "emacs -Q -nw"

mkdir -p ~/.ssh
if ! [ -f ~/.ssh/id_*.pub ]; then
  cd ~/.ssh
  ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -C "vladimir.feinberg@gmail.com" -N ''
  cd
fi
echo "Be sure to register ssh key in ~/.ssh with git acct"

echo "remember to source ~/.bashrc now"
