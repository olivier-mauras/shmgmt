#!/bin/sh
SHELL="/bin/sh"
SRC="${TMPDIR}/files/etc/iptables/iptables.rules"
DST="/etc/iptables/iptables.rules"
SRCSUM=`sha1sum $SRC | cut -f 1 -d ' '`
DSTSUM=`[[ -f $DST ]] && sha1sum $DST | cut -f 1 -d ' ' || echo "nofile"`

if [ "${SRCSUM}" == "${DSTSUM}" ]; then
  exit 2
else
  cp -f ${SRC} ${DST}
  RET=$?
  if [ $RET -gt 0 ]; then
    exit 1
  fi
fi
