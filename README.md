# vg-docker

Vagrant + Docker

## Prerequirements

### Tested configuration:
Tested with:
 - Oracle VirtualBox (with VirtualBox VM Extension Pack) v6.1.18 r142142 (Qt5.6.2) 
 - Vagrant v2.2.15
   - plugins:
     - vagrant-proxyconf (2.0.10, global)
     - vagrant-reload (0.0.1, global)
     - vagrant-vbguest (0.29.0, global)
 - Guest OS: Ubuntu

_NOTE_: to show installed plugins, exec `$ vagrant plugin list`

_NOTE_: vagrant-proxyconf github page: https://github.com/tmatilai/vagrant-proxyconf

## Execution

Execute `$ vagrant up` to initialize (and provision only the first time) the Ubuntu VM with Docker

## Tips

### VirtualBox host / Ubuntu guest: issues with dns resolver

It seems that this Vagrant+VirtualBox configuration produces issues in the Docker DNS resolver. The hosts are reachable within the guest OS, but not in the Docker containers.

In order to fix this, keep **disabled** this line in the Vagrantfile: `vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]`

### Vagrant and VirtualBox provider

The current Vagrant configuration use the Linked VM, in order to speed up any subsequent VM creation of a specific box after the first `vagrant up`

Vagrant will create a first Master VM in VirtualBox, then it will simply create a linked clone from it.

During a box update, Vagrant **will not remove** the Master VM generated in VirtualBox. It has to be done manually.


### Vagrant plugin: vagrant-proxyconf

Behind a proxy, remember to configure your Vagrantfile, or the host system environment variables.

#### Vagrantfile

To configure all possible software on all Vagrant VMs, add the following to _$HOME/.vagrant.d/Vagrantfile_ (or to a project specific _Vagrantfile_):

```ruby
Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://192.168.0.2:3128/"
    config.proxy.https    = "http://192.168.0.2:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
  end
  # ... other stuff
end
```

#### Environment variables

* `VAGRANT_HTTP_PROXY`
* `VAGRANT_HTTPS_PROXY`
* `VAGRANT_FTP_PROXY`
* `VAGRANT_NO_PROXY`

These also override the Vagrantfile configuration. To disable or remove the proxy use an empty value.

For example to spin up a VM, run:

```sh
VAGRANT_HTTP_PROXY="http://proxy.example.com:8080" vagrant up
```

### Vagrant fail to download the image due to SSL issues

Behind corporate proxies, the download of a Vagrant box image could be problematic. The simple command `vagrant up` is unable to download the image, if not present, and it stops the execution with a message error: `The revocation function was unable to check revocation because the revocation server was offline.`

In this case, you should add manually the box through the `add` command, together with the parameter `--insecure` in order to disable SSL checks.
E.g. ` vagrant box add --provider virtualbox --insecure ubuntu/focal64`

### Bash completion

Check the contents of user's `.bashrc` and remove the comments.