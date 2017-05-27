#!/bin/bash
#
# Preps my environment. Does not rely on sudo (downloads, compiles locally).
# Sets up git config, emacs config, and bash config. Presumes all of these
# (and hopefully clang) have already been installed.
#
# Sets up conda, too.

set -e
set -x

FRESH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $FRESH_DIR

printf '\n# My bashrc below\n\n' >> ~/.bashrc
cat .bashrc >> ~/.bashrc
cp -f .bash_defs ~
cp -f .tmux.conf ~

cp -rf bin/ ~

cd
echo "installing conda3"
wget -O conda.sh --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x conda.sh
printf "\nqyes\n\nyes\n" | script --return -c "./conda.sh" /dev/null >/dev/null
rm conda.sh

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
