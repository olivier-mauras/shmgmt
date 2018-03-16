module: directory
=================

#### Options

`-d <DESTINATION>`: Which directory should be taken cared of  
`-u <USER>`: User owner of the directory  
`-g <GROUP>`: Group owner of the directory  
`-g <MODE>`: mode to apply to the directory  

The module will exit with return code `1` if you pass an unknown argument.  
Only destination is mandatory, any missing argument will default to the following values:

- USER: root
- GROUP: root
- MODDE: 750

#### Example

``` bash
${directory} -d /etc/iptables
```
