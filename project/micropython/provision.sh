#!/usr/bin/env bash

# Compile the Micropython firmware
if [ ! -d ~/dev/micropython ]; then
  cd ~/dev
  git clone https://github.com/micropython/micropython.git
fi
cd ~/dev/micropython/esp8266
git pull
make V=1


