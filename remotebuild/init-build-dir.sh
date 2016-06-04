#!/bin/bash

# must be in a directory containing post-recieve-hook
# first parameter should be path to desired repo directory

MY_DIR=$(readlink -f $(pwd))

if [ $# -ne 1 ]; then
  echo usage: $0 build-dir
  exit 1
fi

BUILD_DIR=$1

if ! mkdir $BUILD_DIR ; then
  echo $BUILD_DIR already exists.
  echo Overwriting post-recivie hook.
  cd $BUILD_DIR
else
    cd $BUILD_DIR
    git init
fi

cp $MY_DIR/post-receive-hook .git/hooks/post-receive
chmod 755 .git/hooks/post-receive

echo Succesfully installed hooks in $BUILD_DIR
