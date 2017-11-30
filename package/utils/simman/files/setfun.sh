#!/bin/sh

OPTIND=1

SCRIPT_CFUN="/etc/simman/setfun.gcom"
device=""
IMEI=""
counter=0

while getopts "h?f:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./setfun.sh [option]"
	  echo "Options:"
	  echo " -f - CFUN mode"
	  echo "Example: setfun.sh -f 0"
	  exit 0
	;;
	f) cfun=$OPTARG
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

[ -z "$device" ] && device=$(uci -q get simman.core.atdevice)

# Check if device exists
[ ! -e $device ] && exit 0
while [ "$RESULT" != "$cfun" ]; do
	RESULT=$(COMMAND="=$cfun" gcom -d $device -s $SCRIPT_CFUN)
	sleep 1 
	RESULT=$(COMMAND="?" gcom -d $device -s $SCRIPT_CFUN)
done

exit 0