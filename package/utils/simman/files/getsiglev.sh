#!/bin/sh

OPTIND=1

SCRIPT_SIGLEV="/etc/simman/getsiglev.gcom"
device=""
SIGLEV=99
SIGQUAL=""

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./getsiglev.sh [option]"
	  echo "Options:"
	  echo " -d - AT modem device"
	  echo "Example: getsiglev.sh -d /dev/ttyACM3"
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

SIGLEV=$(gcom -d $device -s $SCRIPT_SIGLEV | grep -e [0-9] | awk -F',' '{print $1}')
[ -z "$SIGLEV" ] && SIGLEV="NONE"


if [ "$SIGLEV" -lt 10 ]; then
	echo "'$SIGLEV ASU (BAD)'"
else 
	if [ "$SIGLEV" -lt 13 ]; then
		echo "'$SIGLEV ASU (NORMAL)'"
	else 
		if [ "$SIGLEV" -lt 18 ]; then
			echo "'$SIGLEV ASU (GOOD)'"
		else 
			if [ "$SIGLEV" -lt 32 ]; then
				echo "'$SIGLEV ASU (EXCELLENT)'"
			else
				echo "'NO SIGNAL'"
			fi
		fi
	fi
fi

