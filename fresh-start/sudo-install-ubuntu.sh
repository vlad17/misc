#!/bin/bash
# Ubuntu-related installs with sudo privledges

# uninstalls stupid ubuntu stuff

set -e

sudo apt-get remove -y gnome-mahjongg gnome-mines gnome-sudoku aisleriot
sudo apt-get remove -y empathy firefox thunderbird rhythmbox 
sudo apt-get -y remove unity-webapps-common webapp-container


cd /tmp

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo apt-get -y install python3-pip python3-dev build-essential
sudo pip install --upgrade pip
sudo apt-get -y install emacs24

sudo apt-get install -y python-dev xclip clang

sudo apt-get remove indicator-messages
sudo add-apt-repository ppa:tsbarnes/indicator-keylock
sudo apt-get update
sudo apt-get -y install indicator-keylock

