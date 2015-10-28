
# Modern IE Vagrant Setup #

## Get the Vagrant Box ##

Clone this repo

```bash
git clone https://github.com/byrney/modern
```

change to the right directory

```bash
    cd modern
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
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default: 
    default: Guest Additions Version: 4.3.10
    default: VirtualBox Version: 5.0
==> default: Mounting shared folders...
    default: /vagrant => /Users/rob/Documents/Vagrant/modern

```

Now you can edit the Vagrantfile to provision your box as usual.

