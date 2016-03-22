#!/usr/bin/env bash

sudo apt-get -y install qt5-qmake libqt5serialport5-dev libudev-dev libftdi-dev git python-git

# Compile the Flash'N'Chips
if [ ! -d ~/dev/fnc ]; then
  cd ~/dev
  git clone https://github.com/cesanta/fnc.git
fi


cd ~/dev/fnc
git pull

QT_SELECT=5 qmake -config cli && make -j 3

# Install
sudo cp ~/dev/fnc/src/FNC-cli /usr/local/bin/.
