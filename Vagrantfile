# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.post_up_message = "*******************
    Log into the box and run a powershell as admin
        $ps> Set-ExecutionPolicy -executionpolicy remotesigned -force
        $ps> . \\vboxsvr\vagrant\vagrant_prepare.ps1
        "
  config.vm.box = "modern81"
  config.vm.communicator = "winrm"
  config.vm.guest = :windows   # guest detection fails: https://github.com/mitchellh/vagrant/pull/4996
  config.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 5985, host: 5985, id: "winrm", auto_correct: true
  config.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 3389, host: 3389, id: "rdp", auto_correct: true

  config.vm.provider "virtualbox" do |v|
        v.gui = true
  end

end
