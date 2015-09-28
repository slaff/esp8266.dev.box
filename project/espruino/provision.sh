#!/usr/bin/env bash
#
# Adds support for Espruino: https://github.com/espruino/Espruino
# 

HAS_EXPORTS=`cat $PROFILE_CONF | grep ESP8266_BOARD || :`
if [ -z "$HAS_EXPORTS" ]; then
  sudo echo "export ESP8266_BOARD=1" >> $PROFILE_CONF
  sudo echo "export ESP8266_SDK_ROOT=\$SDK_BASE" >> $PROFILE_CONF
  sudo echo "export COM_PORT=\$ESPPORT" >> $PROFILE_CONF
  sudo echo "export ESPTOOL_CK=/usr/bin/esptool" >> $PROFILE_CONF
  source $PROFILE_CONF
fi

if [ ! -d ~/dev/Espruino ]; then
   cd ~/dev
   git clone https://github.com/espruino/Espruino.git 
fi 
cd ~/dev/Espruino
git pull
make
