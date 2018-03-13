shmgmt
======

shmgmt is a very simple configuration management tool in pure shell - Except for a [Go binary](https://git.mauras.ch/Various/git-clone) that will handle `git clones`.  
It tries to be fully POSIX shell compliant and has been tested with bash, dash, busybox ash.  

#### Why?

When working with minimalist installs under 100MB on disk, I felt that it didn't really make sense to install a configuration manager that can takes even more size than your full system.  
Typically [this VoidLinux install](https://git.mauras.ch/voidlinux/gw-kvm-install) with an added `unbound` service takes ~70MB on disk.  

As an example here's the size of some tools on VoidLinux:  

- Puppet = 84MB
- Ansible = 60MB
- Salt = 73MB

Using one of this tools would amount to roughly double the disk space, while you already have a shell installed and usable at not cost.  

#### Features

- Self contained, will install itself, set of shell scripts
- Reasonably fast
- Defaults can be overriden from user defined config
- Abstracted modules callable from states by their names `${file}`
- States are easy shell scripts calling on modules: Check [the example repo](https://git.mauras.ch/shmgmt/states_example)

#### Modules list

As of now the following modules exist:

- directory
- file
- void_package
- void_service

#### Installation

``` bash
wget https://git.mauras.ch/shmgmt/shmgmt/raw/branch/master/shmgmt.sh -P /tmp
sh /tmp/shmgmt.sh -i
rm -f /tmp/shmgmt
```

#### Usage

By default `shmgmt` with point its `$STATEREPO` path to [the example repo](https://git.mauras.ch/shmgmt/states_example).  
Override `STATEDIR` in your own config file.

``` bash
echo "STATEREPO=<my own state repo>" > ~/.shmgmt
shmgmt
```
You can also call `shmgmt` to look at an arbitrary located config file

``` bash
shmgmt -c /arbitrary/path/to/shmgmt/config
```

