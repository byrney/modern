# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

    config.vm.box = "modern81"
    config.vm.communicator = "winrm"
    config.vm.guest = :windows   # guest detection fails: https://github.com/mitchellh/vagrant/pull/4996
    config.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 5985, host: 5985, id: "winrm", auto_correct: true
    config.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 3389, host: 3389, id: "rdp", auto_correct: true

    config.vm.provider "virtualbox" do |v|
          v.gui = true
          v.name = "modern8"
          v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end

    # config.vm.provision(:shell, path: "../provision/disable-browser-choice.ps1")
    # config.vm.provision(:shell, path: "../provision/disable-windows-key.ps1")
    # config.vm.provision :shell, path: "../provision/Install-Chocolatey.ps1"
    # config.vm.provision :shell, inline: 'cinst -y chef-client'
    config.vm.provision "chef_solo" do |chef|
        #chef.cookbooks_path = File.expand_path('../chef/chef-repo/cookbooks')
        chef.add_recipe 'winbase'
    end

end
