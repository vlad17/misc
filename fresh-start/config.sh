#!/bin/bash
#
# Preps my environment. Does not rely on sudo (downloads, compiles locally).
# Sets up git config, emacs config, and bash config. Presumes all of these
# (and hopefully clang) have already been installed.

set -e
set -x

FRESH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $FRESH_DIR

echo "copying dotfiles (previous .bashrc moved to .bashrc-old)"
mv $HOME/.bashrc $HOME/.bashrc-old
cp .bashrc $HOME/
cp -f .bash_defs $HOME
cp -f .tmux.conf $HOME

mkdir -p $HOME/bin
cp bin/* $HOME/bin

echo "installing .commacd.bash"
printf '\n# added by installation of ~/.commacd.bash\n' >> ~/.bashrc
curl https://raw.githubusercontent.com/shyiko/commacd/master/commacd.bash -o ~/.commacd.bash && echo "source ~/.commacd.bash" >> ~/.bashrc

if ! which git; then
    echo "No git!"
fi

git config --global user.name "Vladimir Feinberg"
git config --global user.email "vladimir.feinberg@gmail.com"

echo '#!/bin/bash

emacs -Q --no-window-system $@
' > ~/bin/emerge-for-git
chmod 755 ~/bin/emerge-for-git 
git config --global mergetool.emerge.path $HOME/bin/emerge-for-git
git config --global merge.tool emerge

mkdir -p ~/.ssh
if ! [ -f ~/.ssh/id_*.pub ]; then
  cd ~/.ssh
  printf '\n\n\n' | ssh-keygen -t rsa -b 4096 -C "vladimir.feinberg@gmail.com"
  cd
fi
echo "Be sure to register ssh key in ~/.ssh with git acct"

echo "remember to source ~/.bashrc now"
