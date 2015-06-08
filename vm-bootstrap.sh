#!/usr/bin/env bash
set -ex

PROJECT="$1"

# Prepare the machine
sudo apt-get update
sudo apt-get -y install git autoconf build-essential \
     gperf bison flex texinfo libtool libncurses5-dev \
     wget gawk libc6-dev-amd64 python-serial libexpat-dev unzip
if [ ! -d /opt/Espressif ]; then
  sudo mkdir /opt/Espressif
fi
sudo chown vagrant /opt/Espressif

# Build the cross-compiler
cd /opt/

IS_EMPTY=`find Espressif/ -maxdepth 0 -empty -exec echo -n 1 \;`
if [ "$IS_EMPTY" == "1" ]; then
  git clone https://github.com/pfalcon/esp-open-sdk.git Espressif
fi
cd Espressif
git pull
git submodule update
# TODO: if the build fails try to clean the code by uncommenting the line below
# make clean
make STANDALONE=y

export PATH=$PWD/xtensa-lx106-elf/bin/:$PATH

PROFILE_CONF="/etc/profile.d/esp8266.sh"

if [ ! -r  "$PROFILE_CONF" ]; then
  sudo touch "$PROFILE_CONF"
  sudo chown vagrant:vagrant "$PROFILE_CONF" 
fi

# Setup the cross compiler
HAS_PATH=`cat $PROFILE_CONF | grep "# Add Xtensa Compiler Path" || :`
if [ -z "$HAS_PATH" ]; then
  sudo echo "# Add Xtensa Compiler Path" >> $PROFILE_CONF
  sudo echo "export PATH=$PWD/xtensa-lx106-elf/bin/:\$PATH" >> $PROFILE_CONF
  sudo echo "export XTENSA_TOOLS_ROOT=$PWD/xtensa-lx106-elf/bin/" >> $PROFILE_CONF
fi

cd $PWD/xtensa-lx106-elf/bin
chmod u+w .
rm -f xt-*
for i in `ls xtensa-lx106*`; do
  XT_NAME=`echo -n $i | sed s/xtensa-lx106-elf-/xt-/`
  echo "symlinking: $XT_NAME"
  ln -s "$i" "$XT_NAME"
done
sudo ln -s xt-cc xt-xcc # the RTOS SDK needs it
sudo chown vagrant -R /opt/Espressif/xtensa-lx106-elf/bin

HAS_CROSS_COMPILE=`cat $PROFILE_CONF | grep "export CROSS_COMPILE" || :`
if [ -z "$HAS_CROSS_COMPILE" ]; then
  sudo echo "# Cross Compilation Settings" >> $PROFILE_CONF
  sudo echo "export CROSS_COMPILE=xtensa-lx106-elf-" >> $PROFILE_CONF
fi

HAS_SDK_BASE=`cat $PROFILE_CONF | grep "export SDK_BASE" || :`
if [ -z "$HAS_SDK_BASE" ]; then
  sudo echo "# ESP8266 SDK Base" >> $PROFILE_CONF
  sudo echo "export SDK_BASE=/opt/Espressif/sdk/" >> $PROFILE_CONF
  sudo echo "export SDK_EXTRA_INCLUDES=/opt/Espressif/sdk/include/" >> $PROFILE_CONF
fi

# Install ESP tool
IS_ESPTOOL_INSTALLED=`dpkg -s esptool || :`
if [ -z "$IS_ESPTOOL_INSTALLED" ]; then
  cd /tmp
  wget -O esptool_0.0.2-1_i386.deb https://github.com/esp8266/esp8266-wiki/raw/master/deb/esptool_0.0.2-1_i386.deb
  sudo dpkg -i /tmp/esptool_0.0.2-1_i386.deb
  rm /tmp/esptool_0.0.2-1_i386.deb
fi

HAS_FWTOOL=`cat $PROFILE_CONF | grep "export FW_TOOL" || :`
if [ -z "$HAS_FWTOOL" ]; then
  sudo echo "export FW_TOOL=/usr/bin/esptool " >> $PROFILE_CONF
fi

# Install esptool-py
sudo ln -sf /opt/Espressif/esptool/esptool.py /usr/local/bin/
HAS_ESPTOOL=`cat $PROFILE_CONF | grep "export ESPTOOL" || :`
if [ -z "$HAS_ESPTOOL" ]; then
  sudo echo "export ESPTOOL=/usr/local/bin/esptool.py" >> $PROFILE_CONF
  sudo echo "export ESPPORT=/dev/ttyUSB0" >> $PROFILE_CONF
fi

if [ ! -d ~/dev ]; then
  mkdir ~/dev
fi

if [ ! -x /opt/Espressif/sdk/tools/gen_appbin.py ]; then
  sudo chmod a+x /opt/Espressif/sdk/tools/gen_appbin.py
fi

source $PROFILE_CONF

if [ ! -z "$PROJECT" ]; then
  if [ "$PROJECT" == "all" ]; then
    PROJECT="*"
  fi
  FILES=`find /opt/provision/project/$PROJECT -name provision.sh | sort`
  echo "$FILES";
  for i in $FILES; do
    source $i
  done 
fi

