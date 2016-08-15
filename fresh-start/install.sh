#!/bin/bash
#
# Preps my environment. Does not rely on sudo (downloads, compiles locally).
# Sets up git config, emacs config, and bash config. Presumes all of these
# (and hopefully clang) have already been installed.

set -e
set -x

FRESH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if which emacs; then
  EMACS_MAJOR=$(emacs --version | head -1 | cut -f 3 -d " " | cut -f 1 -d .)
  if [ "$EMACS_MAJOR" -lt 24 ]; then
    echo "expecting emacs version >= 24 (major is $EMACS_MAJOR)"
    exit 1
  fi
else
  echo "expecting emacs version >= 24 (none found)"
  exit 1
fi

if ! which git || ! which cmake; then 
  echo "Missing git or cmake!"
  exit 1
fi

cd $FRESH_DIR

printf '# My personal definitions\nsource ~/.bash_defs\n' >> ~/.bashrc
cp .bash_defs ~
cp .tmux.conf ~
cp .gitconfig ~

mkdir -p ~/dev
cd ~/dev
git clone https://github.com/Valloric/ycmd.git
cd ycmd
git submodule update --init --recursive
if which clang; then 
  ./build.py --clang-completer --system-libclang
else
  ./build.py --clang-completer
fi

cd $FRESH_DIR

rm -rf ~/.emacs || true
rm -rf ~/.emacs.d/ || true
cp -r .emacs.d/ ~

cp -rf bin/ ~

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

echo '$HOME/bin/local-anacron.sh' >> ~/.bash_profile

source ~/.bashrc
