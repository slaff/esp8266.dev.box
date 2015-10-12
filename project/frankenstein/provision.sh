#!/usr/bin/env bash

# Compile Frankenstein Firmware
#   Check if we have kconf
KCONF="kconfig-conf";  
X=`whereis "$KCONF"`; 
if [ "$X" == "$KCONF:" ]; then 
  # we should install kconf
  cd /tmp
  wget http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.12.0.0.tar.bz2
  tar xvjf kconfig-frontends-3.12.0.0.tar.bz2
  cd /tmp/kconfig-frontends-3.12.0.0
  ./configure
  make
  sudo make install
fi

X=`whereis pl2303gpio`
if [ "$X" == "pl2303gpio:" ]; then 
  # we should install pl2303gpio
  sudo apt-get -y install libusb-1.0-0-dev pkg-config
  cd /tmp
  git clone https://github.com/nekromant/pl2303gpio.git
  cd pl2303gpio
  make
  sudo make install
fi


if [ ! -d ~/dev/frankenstein ]; then
   cd ~/dev
   git clone https://github.com/nekromant/esp8266-frankenstein.git frankenstein
   cd ~/dev/frankenstein
   # Workaround for an issue with the make script.
   git clone -b experimental https://nekromant@github.com/nekromant/antares.git
   make defconfig # use default config
fi 
cd ~/dev/frankenstein
git pull
make
