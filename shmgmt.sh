#!/bin/sh
# This script tries to be a very stupid configuration management tool but a bit better than
# a simple shell script
# Requires: git

GITREPO="https://git.mauras.ch/Various/shmgmt"
SHELL="/bin/sh"
TMPDIR="/tmp/shmgmt"

# Git clone the repo
if [ ! -d $TMPDIR ]; then
  mkdir -p $TMPDIR
else
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
fi

git clone $GITREPO $TMPDIR

# Get in there and loop over ./run/* scripts
for SCRIPT in ${TMPDIR}/states/* ; do
  BSCRIPT=`basename ${SCRIPT}`
  echo "==> Applying ${BSCRIPT}"
  TMPDIR=${TMPDIR} SHELL=${SHELL} $SHELL ${SCRIPT}
  RET=$?
  if [ $RET -eq 0 ]; then
    echo "==> ${BSCRIPT}: OK"
  elif [ $RET -eq 1 ]; then
    echo "==> ${BSCRIPT}: ERROR!"
  elif [ $RET -eq 2 ]; then
    echo "==> ${BSCRIPT}: NOT NEEDED"
  else
    echo "==> ${BSCRIPT}: Unknown return"
  fi
done
