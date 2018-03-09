#!/bin/sh
# This script tries to be a very stupid configuration management tool but a bit better than
# a simple shell script
# Requires: wget

GITREPO="https://git.mauras.ch/Various/shmgmt"
GITCLONEURL="https://git.mauras.ch/Various/git-clone/raw/branch/master/git-clone"
GITCLONE="/bin/git-clone"
SHELL="/bin/sh"
TMPDIR="/tmp/shmgmt"

# Detect libc version - glibc or musl
echo "==> Detect libc version"
if `ldd --version 2>&1 | head -1 | grep musl`; then
  LIBC="musl"
elif `ldd --version 2>&1 | head -1 | grep GNU`; then
  LIBC="glibc"
else
  echo "  ! Error unknown libc version"
  exit 1
fi

# Check if git-clone is installed, if not install it
if [ ! -f $GITCLONE ]; then
  echo "==> Installing git-clone binary in PATH"
  wget ${GITCLONEURL}_${LIBC} -O /bin/git-clone || exit 1
  chmod 755 /bin/git-clone || exit 1
fi

# Git clone the repo
if [ ! -d $TMPDIR ]; then
  mkdir -p $TMPDIR
else
  rm -rf $TMPDIR
  mkdir -p $TMPDIR
fi

$GITCLONE $GITREPO $TMPDIR > /dev/null 2>&1
RET=$?
if [ $RET -ne 0 ]; then
  echo "  ! Error cloning repo"
  exit 1
fi

# Load dist_check module
. ${TMPDIR}/modules/dist_check

# Get in there and loop over ./run/* scripts
for SCRIPT in ${TMPDIR}/states/* ; do
  BSCRIPT=`basename ${SCRIPT}`
  echo "==> Applying ${BSCRIPT}"
  TMPDIR=${TMPDIR} SHELL=${SHELL} DIST=${DIST} $SHELL ${SCRIPT}
  RET=$?
  if [ $RET -eq 0 ]; then
    echo "==> ${BSCRIPT}: OK"
  elif [ $RET -eq 1 ]; then
    echo "==> ${BSCRIPT}: ERROR!"
  else
    echo "==> ${BSCRIPT}: Unknown return - $RET"
  fi
done

# Cleanup local git clone
rm -rf $TMPDIR
