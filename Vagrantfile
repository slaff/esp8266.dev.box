# -*- mode: ruby -*-
# vi: set ft=ruby :

module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
end

$vendor_id  = '0x067b'
$product_id = '0x2303'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VM_DISPLAY_NAME = "ESP8266-Dev-Box"
VM_HOSTNAME = "esp8266.dev.box"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = VM_HOSTNAME
  config.vm.box = "chef/ubuntu-14.04"
  config.vm.provision :shell, path: "vm-bootstrap.sh", privileged: false, args: "#{ENV['PROJECT']}"
  
  # The toolchain cannot be built on a case-insensitive file system.
  if OS.windows?
     puts "Under Windows the /opt/Espressif folder, where the toolchain is located, cannot be shared."
  else
     config.vm.synced_folder "Espressif/", "/opt/Espressif", owner: "vagrant", group: "vagrant" 	
  end

  config.vm.synced_folder "dev/", "/home/vagrant/dev" 
  config.vm.synced_folder "project", "/opt/provision/project"

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ["modifyvm", :id, "--name", VM_DISPLAY_NAME]
    vb.name = VM_DISPLAY_NAME
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'USB_to_TTL_converter', '--vendorid', $vendor_id, '--productid', $product_id]
  end

end
