#!/bin/bash
#
# Preps my environment. Does not rely on sudo (downloads, compiles locally).
# Sets up git config, emacs config, and bash config. Presumes all of these
# (and hopefully clang) have already been installed.


set -e
set -x

FRESH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $FRESH_DIR

printf '# My personal definitions\nsource ~/.bash_defs\n' >> ~/.bashrc
cp -f .bash_defs ~
cp -f .tmux.conf ~

cp -rf bin/ ~

if ! which git; then
    echo "No git!"
fi

git config --global user.name "Vladimir Feinberg"
git config --global user.email "vyf@princeton.edu"

echo '#!/bin/bash

emacs -Q --no-window-system $@
' > ~/bin/emerge-for-git
chmod 755 ~/bin/emerge-for-git 
git config --global mergetool.emerge.path $HOME/bin/emerge-for-git
git config --global merge.tool emerge

mkdir -p ~/.ssh
if ! [ -f ~/.ssh/id_*.pub ]; then
  cd ~/.ssh
  ssh-keygen -t rsa -b 4096 -C "vyf@princeton.edu"
  cd
fi
echo "Be sure to register ssh key in ~/.ssh with git acct"

echo "remember to source ~/.bashrc now"
