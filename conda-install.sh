#!/bin/bash

cd /tmp
anacondaURL = "https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh"
wget -q "$anacondaURL" -O Anaconda3-4.4.0-Linux-x86_64.sh
chmod +x Anaconda3-4.4.0-Linux-x86_64.sh
./Anaconda3-4.4.0-Linux-x86_64.sh -f -b -p $HOME/anaconda3
export PATH = "$HOME/anaconda3/bin:$PATH"
