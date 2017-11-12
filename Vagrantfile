# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

#  config.vm.provider "virtualbox" do |vb|
#    vb.memory = "4000"
#    vb.cpus = "4"
#  end

  # Install vagrant-vbguest plugin with this command on your host:
  # vagrant plugin install vagrant-vbguest
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y curl
    apt-get install -y rsync

    # for kernel compilation
    echo 'deb http://emdebian.org/tools/debian/ jessie main' > /etc/apt/sources.list.d/emdebian.list
    curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
    dpkg --add-architecture powerpc
    apt-get update
    apt-get install -y crossbuild-essential-powerpc
    apt-get install -y u-boot-tools

    # for rootfs
    apt-get install -y binfmt-support qemu qemu-user-static debootstrap

    # we will build everythin in /mbl to avoid several issues with a mounted VirtualBox directory
    mkdir /mbl
    chown vagrant /mbl
  SHELL
end
