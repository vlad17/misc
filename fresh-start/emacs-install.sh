#!/bin/bash
#
# Installs emacs with autocompletion without use of sudo.
# Should not be sourced.
# Only installs stuff if it's missing.
# Assumes a modern compiler and the following packages are available:
#
# git cmake build-essential python-dev
#
# Requires the following python packages be available when emacs
# is running:
# pylint flake8

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

mkdir -p ~/dev
cd ~/dev

GCC_VERSION=0.0
if which gcc ; then
  GCC_VERSION=$(gcc --version | head -1 | cut -d" " -f 3)
fi
GCC_VERSION_MIN=$(echo $GCC_VERSION 4.8 | tr ' ' '\n' | sort -V | head -1)

if [ "$GCC_VERSION_MIN" = "4.8" ]; then 
    if ! [ -d ycmd ]; then
	git clone https://github.com/Valloric/ycmd.git
    fi
    cd ycmd
    git submodule update --init --recursive
    ./build.py --clang-completer
    rm -rf ~/.emacs || true
    rm -rf ~/.emacs.d/ || true
    cd $FRESH_DIR
    cp -r .emacs.d/ ~

else 
    echo "GCC VERSION $GCC_VERSION_MIN too small for autocomplete - no emacs installed"
    exit 1
fi


