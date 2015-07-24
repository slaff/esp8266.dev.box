#!/usr/bin/env bash


# Compile the Smart.JS firmware
if [ ! -d ~/dev/smart.js ]; then
  cd ~/dev
  git clone https://github.com/cesanta/smart.js.git
fi

cd ~/dev/smart.js
git pull

cd ~/dev/smart.js/platforms/esp8266
make V=1
