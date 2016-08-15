#!/bin/bash
# Installs programs I like. Uses sudo.

cd /tmp

set -e

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo apt-get -y install python3-pip python3-dev build-essential
sudo pip install --upgrade pip
sudo apt-get -y install emacs24

sudo apt-get install -y python-dev xclip clang

sudo apt-get remove indicator-messages
sudo add-apt-repository ppa:tsbarnes/indicator-keylock
sudo apt-get update
sudo apt-get install indicator-keylock
