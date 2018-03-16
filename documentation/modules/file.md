module: file
=================

#### Options

`-d <DESTINATION>`: Which file should be taken cared of  
`-s <SOURCE>`: From which source 
`-u <USER>`: User owner of the directory  
`-g <GROUP>`: Group owner of the directory  
`-g <MODE>`: mode to apply to the directory  
`-b`: Should the destination be copied as `<DESTINATION>.shmgmt.bkp` before being replaced by `<SOURCE>`

The module will exit with return code `1` if you pass an unknown argument.  
Only destination and source are mandatory, any missing argument will default to the following values:

- USER: root
- GROUP: root
- MODE: 750

If a file is repaired then a basenamed `<DESTINATION>.repair` file will be created in `$TMPDIR`. This can be used to notify modules that support this function to act only if the file has been repaired.  
For now `void_service` supports this feature and will only restart a service if `<DESTINATION>.repair` file exist.

#### Example

``` bash
${file} -b -s ${STATEDIR}/files/etc/iptables/iptables.rules \
        -d /etc/iptables/iptables.rules \
        -m 644
```
