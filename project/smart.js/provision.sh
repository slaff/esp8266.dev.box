#!/usr/bin/env bash


# Compile the Smart.JS firmware
if [ ! -d ~/dev/smart.js ]; then
  cd ~/dev
  git clone https://github.com/cesanta/smart.js.git
fi

HAS_SETTINGS=`cat "$PROFILE_CONF" | grep SDK_FLAVOUR || :`
if [ -z "$HAS_SETTINGS" ]; then
  sudo echo "export SDK_FLAVOUR=OSS" >> $PROFILE_CONF
  source $PROFILE_CONF
fi

cd ~/dev/smart.js
git pull

cd ~/dev/smart.js/platforms/esp8266
make V=1
