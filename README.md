# vg-docker

Vagrant + Docker

## Execution


## Tips

### VirtualBox host / Ubuntu guest: issues with dns resolver

It seems that this Vagrant+VirtualBox configuration produces issues in the Docker DNS resolver. The hosts are reachable within the guest OS, but not in the Docker containers.

In order to fix this, keep **disabled** this line in the Vagrantfile: `vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]`

### Vagrant and VirtualBox

The current Vagrant configuration use the Linked VM, in order to speed up any subsequent VM creation of a specific box after the first `vagrant up`

Vagrant will create a first Master VM in VirtualBox, then it will simply create a linked clone from it.

During a box update, Vagrant **will not remove** the Master VM generated in VirtualBox. It has to be done manually.

### Activate bash completion with root user

Open `/root/.bashrc` and remove the comments from lines (~98-100) like:

### 

