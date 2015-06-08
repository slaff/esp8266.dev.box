esp8266-dev
===========

A Vagrant-powered virtual machine providing an isolated development
environment for the [ESP8266](https://github.com/esp8266/esp8266-wiki) $5
dollar "Internet of Things" WiFi module.
It is based on the open-sdk and includes some famous ESP projects like 

* NodeMCU (https://github.com/nodemcu/nodemcu-firmware)
* Micropython (https://github.com/micropython/micropython)
* Sming (https://github.com/anakod/Sming)
* Frankenstein (https://github.com/nekromant/esp8266-frankenstein)

## What you'll need

1. A way to communicate with the chip's 3.3V TTL serial interface. I've had
   success with a [cable from Adafruit](http://www.adafruit.com/product/954)
   that's based on the PL2303 USB-to-TTL module.

2. [VirtualBox](https://www.virtualbox.org/), a free open source virtualization
   package.

3. [Vagrant](https://www.vagrantup.com), a virtualization management tool
   geared towards development environments.


## Let's Do This

0. Clone this repository.

1. If you'll be using a USB-to-TTL device like the Adafruit one I noted above,
   you'll need to edit the `Vagrantfile` to include your device's VendorId and
   ProductId. If you have the exact one I mentioned above, you may be fine with
   the existing configuration, but you may as well do this step too to be sure.
   It's an easy one.

   Connect your device to your computer and from the command line, run
   `VBoxManage list usbhost`. The output should be a list of entries that
   look like this:

        $ VBoxManage list usbhost
        Host USB Devices:
        ...
        UUID:               738b44fd-2f57-49dd-a16a-e31a0e7fa46f
        VendorId:           0x067b (067B)
        ProductId:          0x2303 (2303)
        Revision:           3.0 (0300)
        Port:               1
        USB version/speed:  0/1
        Manufacturer:       Prolific Technology Inc.
        Product:            USB-Serial Controller
        Address:            p=0x2303;v=0x067b;s=0x0002653c8cdc2c52;l=0x14100000
        Current State:      Captured

   Note the VendorId and ProductId. Set the `$vendor_id` and `$product_id`
   variables in `Vagrantfile` to those values. They must be strings of the
   hexadecimal representations.

2a. If you want to create the virtual machine and setup the SDK,  without any ESP8266 projects, run in the console the following command:
```bash
vagrant up
```
This command can take 30 or more minutes on a decent hardware. But you should not worry because it is done only once. Most of it is spent building the cross-compiler.    

2b. If you want to create the virtual machine, setup the SDK and test only one of the available projects then you can run vagrant with the following command on Linux and MacOS X:
```bash
PROJECT="sming" vagrant up
```

Or the commands below for Windows
```bash
set PROJECT="sming"
vagrant up
```

You can replace "sming" in the commands above with any of the available projects, like "micropython", "nodemcu" or "frankenstein".

2c. If you want to create the virtual machine, setup the SDK and test all of the projects then run in the Linux or MacOS X console
```bash
PROJECT="all" vagrant up
```

or the commands below for Windows
```bash
set PROJECT="all"
vagrant up
```

3. That's it! Now you can `vagrant ssh` and start building your images!

4. If you want to update the virtual machine you can run:

```bash
vagrant provision
```

Or 
```bash
PROJECT="sming" vagrant provision
```
To update the SDK and one of your projects.

The respective syntax for Windows is:
```bash
set PROJECT="sming"
vagrant provision
```

Or 
```bash
PROJECT="all" vagrant provision
```

The respective syntax for Windows is:
```bash
set PROJECT="all"
vagrant provision
```

To update the SDK and all of your projects.

## USB access
Make sure the serial cable is working.  With it plugged in, `vagrant ssh` into the machine and
run `lsusb` to make sure it's in your list of devices. To see where it's
attached, run `dmesg` and somewhere near the bottom you should see something
like `usb 1-1: pl2303 converter now attached to ttyUSB0`. If not, you might try
unplugging it and plugging it back in, then running it again -- that way it'll
definitely be near the bottom of the log. If your device is attached anywhere
besides `/dev/ttyUSB0`, you'll need to adjust your scripts and Makefiles as
appropriate. No big deal.

Make sure that with the user, from which you started vagrant, is able to access
/dev/ttyUSB0. If the following command does not produce any results:

$ VBoxManage list usbhost

Then make sure to add that user into the vagrant group. This can be done with:

sudo useradd -G vargrant {username}

Replace {username} with the correct value. 

## Vagrant tips, for the uninitiated

The project's root directory is mirrored to `/vagrant` on the virtual machine.

You can `sudo` from inside the machine without a password.

`vagrant ssh` - ssh into the machine

`vagrant provision` - runs the provisioning script. You can run this command every time you want
to get the latest version of the SDK and the projects that are in dev.

`vagrant halt` - shuts down the machine

`vagrant suspend` - puts the machine to sleep

`vagrant destroy` - removes every trace of the machine. NOTE: after a destroy,
the next `vagrant up` will have to reprovision the machine from scratch,
meaning it'll take a while.

`vagrant up` - spins up the machine, bringing it back up from `halt`,
`suspend`, or `destroy`


## ESP8266 Resources

- https://github.com/esp8266/esp8266-wiki - the wiki containing everything I
  needed to build this repo
- http://esp8266.com - a forum for people interested in hacking on the chip
- `#esp8266` on Freenode
- http://www.electrodragon.com/w/Wi07c - another nice wiki I found useful for
  exploring the AT commands


## A final note

This box started as a fork of that project:
https://github.com/mziwisky/esp8266-dev
Thanks to mziwiski for his initial work.
