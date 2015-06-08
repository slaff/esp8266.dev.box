#!/usr/bin/env bash

# Compile the NodeMCU firmware
cd ~/dev
if [ ! -d ~/dev/nodemcu-firmware ]; then
  git clone https://github.com/nodemcu/nodemcu-firmware.git
fi
cd nodemcu-firmware
git pull
make

