#!/bin/bash

cd
mkdir -p dev

if [ -z "$1" ]; then
    DEST="$HOME/dev/anaconda3"
else
    DEST="$1"
fi

cd /tmp
anacondaURL="https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh"
wget -q "$anacondaURL" -O Anaconda3-4.4.0-Linux-x86_64.sh
chmod +x Anaconda3-4.4.0-Linux-x86_64.sh
./Anaconda3-4.4.0-Linux-x86_64.sh -f -b -p $DEST
echo "# added by conda-install.sh" >> ~/.bashrc
echo "export PATH=\"$DEST/bin:\$PATH\"" >> ~/.bashrc
