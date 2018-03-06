#!/bin/sh
SHELL="/bin/sh"
SRC="${TMPDIR}/files/etc/iptables/iptables.rules"
DST="/etc/iptables/iptables.rules"
SRCSUM=`[ -f $SRC ] && sha1sum $SRC | cut -f 1 -d ' ' || echo "nosrc"`
DSTSUM=`[ -f $DST ] && sha1sum $DST | cut -f 1 -d ' ' || echo "nodst"`

if [ "${SRCSUM}" = "${DSTSUM}" ]; then
  exit 2
else
  # Exit if we miss the source file
  if [ "${SRCSUM}" = "nosrc" ]; then
    echo "  ! Missing source file ${SRC}"
    exit 1
  fi
  cp -f ${SRC} ${DST}
  RET=$?
  if [ $RET -gt 0 ]; then
    exit 1
  fi
fi

# If file has been successfully changed, restart service
$SHELL ${TMPDIR}/states/service iptables
