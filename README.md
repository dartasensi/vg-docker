# vg-docker

Vagrant + Docker

## Prerequirements

### Tested configuration:
 - Oracle VirtualBox (with VirtualBox VM Extension Pack) v6.1.18 r142142 (Qt5.6.2) 
 - Vagrant v2.2.15
   - plugins: (to show installed list, exec `$ vagrant plugin list`)
     - vagrant-proxyconf (2.0.10, global)
     - vagrant-reload (0.0.1, global)
     - vagrant-vbguest (0.29.0, global)
 - Guest OS: Ubuntu 20.10

## Execution

## Tips

### VirtualBox host / Ubuntu guest: issues with dns resolver

It seems that this Vagrant+VirtualBox configuration produces issues in the Docker DNS resolver. The hosts are reachable within the guest OS, but not in the Docker containers.

In order to fix this, keep **disabled** this line in the Vagrantfile: `vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]`

### Vagrant and VirtualBox

The current Vagrant configuration use the Linked VM, in order to speed up any subsequent VM creation of a specific box after the first `vagrant up`

Vagrant will create a first Master VM in VirtualBox, then it will simply create a linked clone from it.

During a box update, Vagrant **will not remove** the Master VM generated in VirtualBox. It has to be done manually.

### Vagrant fail to download the image due to SSL issues

Behind corporate proxies, the download of a Vagrant box image could be problematic. The simple command `vagrant up` is unable to download the image, if not present, and it stops the execution with a message error: `The revocation function was unable to check revocation because the revocation server was offline.`

In this case, you should add manually the box through the `add` command, together with the parameter `--insecure` in order to disable SSL checks.
E.g. ` vagrant box add --provider virtualbox --insecure ubuntu/focal64`

### Activate bash completion with root user

Open `/root/.bashrc` and remove the comments from lines (~98-100) like:
_TODO_
