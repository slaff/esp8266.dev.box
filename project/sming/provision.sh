#!/usr/bin/env bash


# Compile Spiffy
if [ ! -d ~/dev/spiffy ]; then
  git clone -b sming https://github.com/alonewolfx2/spiffy
fi
cd ~/dev/spiffy
git pull
if [ ! -d ~/dev/spiffy/build ]; then
  mkdir build
fi
make 
sudo ln -s /home/vagrant/dev/spiffy/build/spiffy /usr/local/bin/spiffy


# Compile the Sming firmware
if [ ! -d ~/dev/Sming ]; then
  cd ~/dev
  git clone https://github.com/anakod/Sming.git
fi

HAS_SMING_HOME=`cat $PROFILE_CONF | grep SMING_HOME || :`
if [ -z "$HAS_SMING_HOME" ]; then
  sudo echo "export ESP_HOME=/opt/Espressif" >> $PROFILE_CONF
  sudo echo "export SMING_HOME=/home/vagrant/dev/Sming/Sming/" >> $PROFILE_CONF 
  sudo echo "export COM_PORT=/dev/ttyUSB0" >> $PROFILE_CONF
  source $PROFILE_CONF
fi
cd ~/dev/Sming
git pull
cd ~/dev/Sming/Sming
make V=1
