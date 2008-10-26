#!/bin/sh
# This is add-dev.sh,
# a script to add a device node to devs.tar
#
# SYNAPSIS:
# $ add-dev.sh <path> <type> <major> <minor>
#
# You can optionally set ROOTCMD environment variable to override sudo
# with something of your preference.
# Prerequisites: mktemp (supporting -d), mknod, tar, bourne shell
#
# 2007 Alexander Shishkin <virtuoso@slind.org>

# arguments
PATH="$1"
TYPE="$2"
MAJ="$3"
MIN="$4"
if [ -z "$PATH" -o -z "$TYPE" -o -z "$MAJ" -o -z "$MIN" ]; then
	echo "Something screwed on the command line"
	exit 1
fi

if [ -z "$ROOTCMD" ]; then
	ROOTCMD=/usr/bin/sudo
fi
MKTEMP=/bin/mktemp
TAR=/bin/tar
MKNOD=/bin/mknod

if [ -z "$DEVSTAR" ]; then
	DEVSTAR=`pwd`/devs.tar
fi

DIR=`$MKTEMP -d`

# unpack existing devs.tar
if [ -f "$DEVSTAR" ]; then
	$ROOTCMD $TAR xf $DEVSTAR -C $DIR
else
	echo "Device nodes archive $DEVSTAR not found, will create one"
	mkdir $DIR/dev
fi

$ROOTCMD mknod $DIR/dev/$PATH $TYPE $MAJ $MIN
( cd $DIR; $ROOTCMD $TAR cf $DEVSTAR dev )

