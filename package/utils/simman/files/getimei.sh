#!/bin/sh

OPTIND=1

SCRIPT_IMEI="/etc/simman/getimei.gcom"
device=""
IMEI=""
counter=0

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./getimei.sh [option]"
	  echo "Options:"
	  echo " -d - AT modem device"
	  echo "Example: getimei.sh -d /dev/ttyACM3"
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

	IMEI=$(gcom -d $device -s $SCRIPT_IMEI)

[ -z "$IMEI" ] && IMEI="NONE"

echo $IMEI

