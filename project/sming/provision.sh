#!/usr/bin/env bash

# Compile Spiffy
if [ ! -d ~/dev/spiffy ]; then
  cd ~/dev
  git clone -b sming https://github.com/alonewolfx2/spiffy
fi
cd ~/dev/spiffy
git pull
if [ ! -d ~/dev/spiffy/build ]; then
  mkdir build
fi
make 
sudo ln -sf /home/vagrant/dev/spiffy/build/spiffy /usr/local/bin/spiffy


# Compile the Sming firmware
if [ ! -d ~/dev/Sming ]; then
  cd ~/dev
  git clone https://github.com/anakod/Sming.git
fi

HAS_SMING_HOME=`cat $PROFILE_CONF | grep SMING_HOME || :`
if [ -z "$HAS_SMING_HOME" ]; then
  sudo echo "export ESP_HOME=/opt/Espressif" >> $PROFILE_CONF
  sudo echo "export SMING_HOME=/home/vagrant/dev/Sming/Sming/" >> 
$PROFILE_CONF 
  sudo echo "export COM_PORT=/dev/ttyUSB0" >> $PROFILE_CONF
  source $PROFILE_CONF
fi

# rBoot Settings
cd ~/dev
if [ ! -e ~/dev/raburton-esp8266 ]; then
  git clone https://github.com/raburton/esp8266 raburton-esp8266
fi
cd ~/dev/raburton-esp8266/esptool2
export XTENSA_BINDIR=$XTENSA_TOOLS_ROOT
make 

HAS_ESPTOOL2=`cat $PROFILE_CONF | grep ESPTOOL2 || :`
if [ -z "$HAS_ESPTOOL2" ]; then
  sudo echo "export ESPTOOL2=`pwd`/esptool2" >>  $PROFILE_CONF
  source $PROFILE_CONF
fi 

cd ~/dev/Sming
git pull
cd ~/dev/Sming/Sming
make V=1

