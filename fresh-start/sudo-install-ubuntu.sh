#!/bin/bash
# Ubuntu-related installs with sudo privledges

# uninstalls stupid ubuntu stuff

set -e

sudo apt-get remove -y gnome-mahjongg gnome-mines gnome-sudoku aisleriot
sudo apt-get remove -y empathy firefox thunderbird rhythmbox 
sudo apt-get -y remove unity-webapps-common webapp-container

cd /tmp

sudo apt-get update
sudo apt-get -y install git

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
if ! sudo dpkg -i google-chrome-stable_current_amd64.deb; then
    sudo apt-get install -yf
fi

sudo apt-get -y install emacs24

sudo apt-get install -y xclip clang cmake build-essential python-dev

sudo apt-get remove -y indicator-messages
sudo add-apt-repository -y ppa:tsbarnes/indicator-keylock
sudo apt-get update
sudo apt-get -y install indicator-keylock

