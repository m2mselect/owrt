#!/bin/sh

OPTIND=1

SCRIPT_PINSTAT="/etc/simman/getpinstat.gcom"
device=""
PINSTAT=""

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./getpinstat.sh [option]"
	  echo "Options:"
	  echo " -d - AT modem device"
	  echo "Example: getpinstat.sh -d /dev/ttyACM3"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

[ -z "$device" ] && device=$(uci -q get simman.core.atdevice)

# Check if device exists
[ ! -e $device ] && exit 0

PINSTAT=$(gcom -d $device -s $SCRIPT_PINSTAT)
[ -z "$PINSTAT" ] && PINSTAT="NONE"

echo $PINSTAT

