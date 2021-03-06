shmgmt
======

shmgmt is a very simple configuration management tool in pure shell - Except for a [Go binary](https://git.mauras.ch/Various/git-clone) that will handle `git clones`.  
It tries to be fully POSIX shell compliant and has been tested with bash, dash, busybox ash.  

#### Why?

When working with minimalist installs under 100MB on disk, it doesn't really make sense to install a configuration manager that can take even more size than your full system.  
Typically [this VoidLinux install](https://git.mauras.ch/voidlinux/gw-kvm-install) with an added `unbound` service takes ~70MB on disk.  

As an example here's the size of some tools on VoidLinux:  

- Ansible = 60MB
- Puppet = 84MB
- Salt = 73MB

Using one of this tools would amount to roughly double the disk space, while you already have a shell installed and usable at not cost.  

#### Features

- Self contained - will install itself locally - set of shell scripts
- Reasonably fast
- Sync states from a Git repo
- Defaults can be overriden from user defined config
- Abstracted modules callable from states by their names, like: `${file}`
- States are easy shell scripts calling on modules: Check [the example repo](https://git.mauras.ch/shmgmt/states_example)

#### Modules list

As of now the following modules exist:

- directory
- file
- void_package
- void_service

You can check per module documentation [here](./documentation/modules)

#### Installation

``` bash
wget https://git.mauras.ch/shmgmt/shmgmt/raw/branch/master/shmgmt.sh -P /tmp
sh /tmp/shmgmt.sh -i
rm -f /tmp/shmgmt
```

#### Usage

By default `shmgmt` will point its `$STATEREPO` path to [the example repo](https://git.mauras.ch/shmgmt/states_example).  
Override `$STATEREPO` in your own config file.

``` bash
echo "STATEREPO=<my own state repo>" > ~/.shmgmt
shmgmt
```
You can also call `shmgmt` to look at an arbitrary located config file

``` bash
shmgmt -c /arbitrary/path/to/shmgmt/config
```

#### Options

``` 
-i: Install itself locally
-c <CONFIG>: Specify config file
-r <STATEREPO>: Git repo containing your state files
-d <STATEDIR>: Where to clone your states files locally
```
