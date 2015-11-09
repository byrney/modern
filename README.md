
# Modern IE Vagrant Setup with Chef #

1. Install Prerequisites
2. Get the Vagrant Box for IE Modern
3. Prepare the guest
4. Start up and provision with chef + vagrant

## Prerequisites ##

### Install Virtualbox ###


### Install vagrant on the host ###

Either download it from here

    https://www.vagrantup.com/downloads

or use you package manager of choice

### Install chef dev kit on the host ###

Download from opscode

    https://downloads.chef.io/chef-dk/

or, again, use you package manager

### Install the vagrant-berkshelf-plugin ##

Once vagrant is install this can be done with 

    vagrant plugin install vagrant-berkshelf

on the commandline  (see   https://github.com/berkshelf/vagrant-berkshelf  for
more details )

## Get the Vagrant Box ##

Clone this repo

```bash
git clone https://github.com/byrney/modern
```

change to the right directory and branch

```bash
    cd modern
    git checkout chef
```

Get the box  (this may take a while)

```bash
    vagrant box add modern81 'http://aka.ms/vagrant-win81-ie11'
```

## Set up the guest ##

Start the VM

```bash
    vagrant up
```

the box will start in the VirtualBox GUI but vagrant will fail because the box
has not be set-up to allow remote access (see below for example of the error).

You should see this:

```
> vagrant up

Bringing machine 'default' up with 'virtualbox' provider...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 5985 => 5985 (adapter 1)
    default: 3389 => 3389 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: WinRM address: 127.0.0.1:5985
    default: WinRM username: vagrant
    default: WinRM transport: plaintext
An error occurred executing a remote WinRM command.

Shell: powershell
Command: hostname
if ($?) { exit 0 } else { if($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }
Message: Protocol wrong type for socket
```

Go to the VM GUI and open a command window as admin (right click on the start
button and select from the menu). Then

```PowerShell
powershell
Set-ExecutionPolicy -executionpolicy remotesigned -force
net use z: \\vboxsvr\vagrant
. z:\vagrant_prepare.ps1
```

this should prep-the box for vagrant to be able to connect via winrm as user
`vagrant`.  (Currently the prepare script has an error setting up rdp.
Continue and the rest should be ok).

It will also install chef-client by downloading the MSI from opscode

Let it reboot so that the updates get installed.

## Optionally save the prepared image ##

If you plan on creating many VMs with this box then it's probably worth
updating the box in vagrant with the prepare script and updates applied.

1.  Shut down the VM

    vagrant halt

2.  Back on the host, Export/Package the box

    vagrant package --base modern81 --out modern81.box

3.  Once the box is created import it

    vagrant box add --name modern81 --provider virtualbox  --force modern81.box

Once imported this will be version 2 of your modern81 box. Next time vagrant
starts it will use the new one.

You can delete the `modern81.box` file now.

## Start up with vagrant ##

Shut down the box using the VM Gui, return to your host terminal and try

```bash
vagrant up
```

When the prepare script has worked you will see this:

```
> vagrant up

Bringing machine 'default' up with 'virtualbox' provider...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 5985 => 5985 (adapter 1)
    default: 3389 => 3389 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: WinRM address: 127.0.0.1:5985
    default: WinRM username: vagrant
    default: WinRM transport: plaintext
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: Guest Additions Version: 4.3.10
    default: VirtualBox Version: 5.0
==> default: Mounting shared folders...
    default: /vagrant => /Users/rob/Documents/Vagrant/modern

```

The box will provision using chef-solo running the recipe in
`winbase/recipes/default.rb`

