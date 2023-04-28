# metomi-vms

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1341042.svg)](https://doi.org/10.5281/zenodo.1341042)

Vagrant virtual machines with [FCM](http://metomi.github.io/fcm/doc/) + [Rose](http://metomi.github.io/rose/) + [Cylc](http://cylc.github.io/cylc/) installed.

Table of contents:
* [Software Requirements](#software-requirements)
* [Setting up the Default Virtual Machine](#setting-up-the-default-virtual-machine)
* [Using the Default Virtual Machine](#using-the-default-virtual-machine)
* [Disabling the Desktop Environment](#disabling-the-desktop-environment)
* [Using other Virtual Machines](#using-other-virtual-machines)
* [Optional Windows Software](#optional-windows-software)
  * [Git BASH](#git-bash)
  * [Cygwin](#cygwin)
* [VMware](#vmware)
* [libvirt](#libvirt)
* [Troubleshooting](#troubleshooting)
* [Amazon AWS](doc/README_AWS.md)
* [Microsoft Azure](doc/README_Azure.md)

## Software Requirements

In order to use a virtual machine (VM), you must first install:
 * [VirtualBox](https://www.virtualbox.org/), software that enables running of virtual machines (version 5.1.x or later required).
   * As an alternative, [VMware Workstation Player](https://www.vmware.com/uk/products/workstation-player.html) (version 16 or later) or [VMware Fusion Player](https://www.vmware.com/uk/products/fusion.html) (version 12 or later) can also be used to run the virtual machine. See the [VMware section](#vmware) for further information.
 * [Vagrant](https://www.vagrantup.com/), software that allows easy configuration of virtual machines (version 2.0.x or later required).

These applications provide point-and-click installers for Windows and can usually be installed via the package manager on Linux systems.

## Setting up the Default Virtual Machine

After you have installed VirtualBox and Vagrant, download the metomi VM setup files from github:
 * https://github.com/metomi/metomi-vms/archive/master.zip.

Then extract the files which will be put into a directory called `metomi-vms-master`.

The default VM uses Ubuntu 18.04.
If necessary you can customise the VM by editing the file `Vagrantfile.ubuntu-1804` as follows:
* By default the VM will be built with support for accessing the Met Office Science Repository Service.
  If you don't want this (or don't have access) then remove `mosrs` from the `args` in the `config.vm.provision` line.
* As described below, you may prefer not to install the desktop environment.
  To do this remove `desktop` from the `args` in the `config.vm.provision` line and comment out the line `v.gui = true`.
* By default the VM is configured with 1 GB memory and 2 CPUs.
  You may want to increase these if your host machine is powerful enough.

See the [Vagrant documentation](https://docs.vagrantup.com/v2/virtualbox/configuration.html) for more details on configuration options.

Before proceeding you need to be running a terminal with your current directory set to `metomi-vms-master`.
* Windows users can navigate to the directory using Windows File Explorer and then use `Shift-> Right Mouse Click -> Open command window here`.

Now run the command `vagrant up` to build and launch the VM.
This involves downloading a base VM and then installing lots of additional software so it can take a long time (depending on the speed of your internet connection).
Note that, although a login screen will appear in a separate window, you will not be able to login at this stage.
Once the installation is complete the VM will shutdown.

## Using the Default Virtual Machine

Run the command `vagrant up` to launch the VM.
A separate window should open containing a lightweight Linux desktop environment ([LXDE](http://lxde.org/)) with a terminal already opened.

If your VM includes support for the Met Office Science Repository Service then you will be prompted for your password (and also your user name the first time you use the VM).
If you get your username or password wrong and Subversion fails to connect, just run `mosrs-cache-password` to try again.

The VM is configured with a local [Rose suite repository](http://metomi.github.io/rose/doc/html/tutorial/rose/rosie.html) and with the suite log viewer running under apache.
If you want to learn more about Rose and Cylc you can follow the tutorials contained in the [Rose User Guide](http://metomi.github.io/rose/).

To shutdown the VM you can either use the menu item available in the bottom right hand corner of the Linux desktop or you can issue the command `vagrant halt` from the command window where you launched the VM.

Note that the desktop environment is configured to use a UK keyboard.
If you need to change this, take a look at how this is configured in the file `install-desktop.sh`.

## Disabling the Desktop Environment

If you are using the VM on a Mac or Linux system where you already have a X server running then you may find it easier to not install the desktop environment.
In order to do this, edit the file `Vagrantfile.ubuntu-1804` as described above.
Then run the command `vagrant up` to launch the VM in the normal way.
Note that, unlike when installing the desktop environment, it will not shutdown after the initial installation.

Once the VM is running, run the command `vagrant ssh` to connect to it.

To shutdown the VM you can either run the command `sudo shutdown -h now` from within your ssh session or you can exit your ssh session and then issue the command `vagrant halt`.

## Using other Virtual Machines

In addition to the default VM, additional VMs are supported in separate files named `Vagrantfile.<distribution>`, e.g. `Vagrantfile.centos-7`.
These other VMs are provided primarily for the purpose of testing FCM, Rose & Cylc on other Linux distributions and providing a reference install on these platforms.
Note that they are not as well tested as the default VM and may not include a desktop environment.

To use a different VM, modify the file which is loaded in the default `Vagrantfile` before running `vagrant up`.
Alternatively you can set the environment variable `VAGRANT_VAGRANTFILE`, for example:
```
export VAGRANT_VAGRANTFILE=Vagrantfile.ubuntu-1604
```
(use `set` in place of `export` when using the command window on Windows).

## Optional Windows Software

### Git BASH

For an alternative to the normal command window, Windows users can install Git BASH (which comes with [Git for Windows](https://git-for-windows.github.io/)).
As well as providing a nicer interface (more familiar for Linux users) this also means that you can use git to clone the metomi-vms repository (instead of downloading the zip file):
```
git clone https://github.com/metomi/metomi-vms.git
```
It is then easy to track any local changes, pull down updates, etc.

### Cygwin

If you want to run a VM without a desktop environment on Windows then, in order to enable GUI programs to work, you will need to install [Cygwin](https://www.cygwin.com/), making sure to select the `xinit` and `xorg-server` packages from the `X11` section and the `openssh` and `openssl` packages from the `Net` section.

Then, instead of using a normal command window for launching the VM, you should use a Cygwin-X terminal, which you can find in the Start Menu as `Cygwin-X > XWin Server`.
In Cygwin-X terminals, you can use many common Unix commands (e.g. cd, ls).
Firstly run the command  `cd /cygdrive` followed by `ls` and you should see your Windows drives.
Then use the `cd` command to navigate to the directory where you have extracted the setup files (e.g. `c/Users/User/metomi-vms-master`).

## VMware

As an alternative to VirtualBox, [VMware Workstation Player](https://www.vmware.com/uk/products/workstation-player.html) (Windows, Linux) or ([VMware Fusion Player](https://www.vmware.com/uk/products/fusion.html) (macOS) can be used to host the virtual machine. VMware Workstation Player is free for non-commercial use and VMware Fusion Player is free with a Personal Use License.

You will need to download and install

* [VMware Workstation Player](https://www.vmware.com/uk/products/workstation-player.html) (version 16 or later) **or** [VMware Fusion Player](https://www.vmware.com/uk/products/fusion.html) (version 12 or later)
* The [Vagrant VMware utility](https://www.vagrantup.com/vmware/downloads)
* The Vagrant VMware plugin by running the command `vagrant plugin install vagrant-vmware-desktop`

The configuration settings can be found in the [Vagrantfile.vmware_ubuntu-1804](Vagrantfile.vmware_ubuntu-1804) file. To bring the box up using VMware, you should [set your VAGRANT_VAGRANTFILE](#using-other-virtual-machines) to `Vagrantfile.vmware_ubuntu-1804` before running the command
```
vagrant up --provider=vmware_desktop
```
You may have issues if both VMware and VirtualBox are installed, or if the Hyper-V hypervisor is also running. If you are using an Apple Silicon device with VMware Fusion you will need to set the following
```
config.vm.box = "uwbbi/bionic-arm64"
```
in the [Vagrantfile.vmware_ubuntu-1804](Vagrantfile.vmware_ubuntu-1804) file as you cannot use an amd64-based installation on Apple Silicon (ARM-based) hardware.

## libvirt

Another alternative to VirtualBox and VMware is to use the [libvirt virtualisation API](https://libvirt.org/index.html), which also has a [Vagrant plugin](https://vagrant-libvirt.github.io/vagrant-libvirt/). You will need to install libvirt on your host system. You should [set your VAGRANT_VAGRANTFILE](#using-other-virtual-machines) to [Vagrantfile.libvirt_ubuntu-1804](Vagrantfile.libvirt_ubuntu-1804) before running the command
```
vagrant up --provider=libvirt
```
to provision the VM. The current [Vagrantfile](Vagrantfile.libvirt_ubuntu-1804) has been used on a GNU/Linux host without a graphical login.

The advantage of this method is that it allows for PCI passthrough, allowing the guest OS to directly access hardware on the host, for instance allowing the guest to access a GPU on the host machine. On a GNU/Linux system you can use the `lspci -v` command to determine the device information, and then include a block such as this within the `config.vm.provider` section of the [Vagrantfile.libvirt_ubuntu-1804](Vagrantfile.libvirt_ubuntu-1804) file:
```
    # VGA controller on 65:00.0
    v.pci :domain => '0x0000', :bus => '0x65', :slot => '0x00', :function => '0x0'
    # Audio controller on 65:00.1
    v.pci :domain => '0x0000', :bus => '0x65', :slot => '0x00', :function => '0x1'
    # USB controller on 65:00.2
    v.pci :domain => '0x0000', :bus => '0x65', :slot => '0x00', :function => '0x2'
    # Serial bus controller on 65:00.3
    v.pci :domain => '0x0000', :bus => '0x65', :slot => '0x00', :function => '0x3'
```
This step needs to be done on the initial creation of the VM. The GPU would also need to be isolated from the host system.

## Troubleshooting

### Guest display resolution

When you resize the VirtualBox window (e.g. to mazimise it) the display resolution of your Linux VM should adjust to match.
If this doesn't work it may be due to the Guest Additions installed in your VM not matching the version of VirtualBox you have installed.
The easiest way to fix this is to install the [vagrant-vbguest Vagrant plugin](https://github.com/dotless-de/vagrant-vbguest).
Note that, if the plugin does update your Guest Additions then you will need to shutdown and restart your VM (using `vagrant up`) in order for them to take effect.
