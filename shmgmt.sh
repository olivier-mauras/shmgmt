#!/bin/sh

CONFIG=~/.shmgmt
INSTALLDIR="/usr/local/libexec/shmgmt"
INSTALLBIN="/usr/local/bin/shmgmt"
SHMGMTREPO="https://git.mauras.ch/shmgmt/shmgmt"
STATEREPO="https://git.mauras.ch/shmgmt/states_example"
STATEDIR="/tmp/shmgmt"
GITCLONEURL="https://git.mauras.ch/Various/git-clone/raw/branch/master/git-clone"
GITCLONEBIN="/usr/local/bin/git-clone"
SHELL="/bin/sh"

_install_gitclone() {
  # Check if git-clone is installed, if not install it
  if [ ! -f $GITCLONEBIN ]; then
    echo "==> Installing git-clone binary in PATH"
    [ ! -d `dirname $GITCLONEBIN` ] && mkdir -p `dirname $GITCLONEBIN`
    wget ${GITCLONEURL}_${LIBC} -O $GITCLONEBIN || exit 1
    chmod 755 $GITCLONEBIN || exit 1
  fi
}

_clone_repo() {
  URL=$1
  DESTDIR=$2

  # Ensure that $DESTDIR is clean
  if [ ! -d $DESTDIR ]; then
    mkdir -p $DESTDIR
  else
    rm -rf $DESTDIR
    mkdir -p $DESTDIR
  fi

  echo "==> Cloning $URL to $DESTDIR"
  $GITCLONEBIN $URL $DESTDIR > /dev/null 2>&1
  RET=$?
  if [ $RET -ne 0 ]; then
    echo "  ! Error cloning repo"
    exit 1
  fi
}

_install() {
  INSTALLDIR="$1"

  echo "==> Install shmgmt locally"

  # Detect libc version - glibc or musl
  echo "==> Detect libc version"
  if `ldd --version 2>&1 | head -1 | grep musl >/dev/null 2>&1`; then
    LIBC="musl"
  elif `ldd --version 2>&1 | head -1 | grep GNU >/dev/null 2>&1`; then
    LIBC="glibc"
  else
    echo "  ! Error unknown libc version"
    exit 1
  fi

  # Ensure git-clone binary is deployed
  _install_gitclone

  # Now install shmgmt locally
  _clone_repo $SHMGMTREPO $INSTALLDIR

  # Create shmgmt symlink
  ln -sf ${INSTALLDIR}/shmgmt.sh $INSTALLBIN || exit 1

  exit 0
}

_process_states() {
  INSTALLDIR=$1
  STATEDIR=$2

  # Now install shmgmt locally
  _clone_repo $STATEREPO $STATEDIR

  # Load libs
  for LIB in ${INSTALLDIR}/libs/*; do
    . ${LIB}
  done

  for MODULE in ${INSTALLDIR}/modules/*; do
    if [ `echo $MODULE | grep ${DIST}` ]; then
      export `basename $MODULE | cut -f 2- -d _`="${SHELL} ${MODULE}"
    else
      export `basename $MODULE`="${SHELL} ${MODULE}"
    fi
  done

  # Loop over states
  for STATE in ${STATEDIR}/states/* ; do
    BSTATE=`basename ${STATE}`
    echo "==> Applying ${BSTATE}"
    STATEDIR=${STATEDIR} \
      DIST=${DIST} \
      $SHELL ${STATE}
    RET=$?
    if [ $RET -eq 0 ]; then
      echo "==> ${BSTATE}: OK"
    elif [ $RET -eq 1 ]; then
      echo "==> ${BSTATE}: ERROR!"
    else
      echo "==> ${BSTATE}: Unknown return - $RET"
    fi
  done
}

_cleanup() {
  # Cleanup local git clone
  rm -rf $STATEDIR
}

# Retrieve arguments
while getopts ":c:r:di" opt; do
  case $opt in
    c)
        CONFIG=$OPTARG
        ;;
    r)
        STATEREPO=$OPTARG
        ;;
    d)
        STATEDIR=$OPTARG
        ;;
    i)
        _install $INSTALLDIR
        ;;
    *)
        echo "  ! Unknown parameter \"$PARAM\""
        exit 1
        ;;
  esac
done
shift $((OPTIND -1))

# Load config if it exists
if [ ! -z $CONFIG ] && [ -f $CONFIG ]; then
  echo "==> Loading user config"
  . $CONFIG
fi

# Sanity check
if [ -z $STATEREPO ] || [ -z $STATEDIR ] || [ -z $INSTALLDIR ]; then
  echo "!! Missing needed variables STATEREPO, STATEDIR or INSTALLDIR to work"
fi

# Clone and process states
_process_states $INSTALLDIR $STATEDIR
