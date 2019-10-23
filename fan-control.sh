#!/bin/bash

if [ ! -f idrac-creds.sh ]; then
        echo "IDRAC credentials file not found...aborting"
        exit 0
    else
        source idrac-creds.sh
fi

DATE=$(date +%Y-%m-%d-%H:%M:%S)
SET_SPEED="16" # This is number 16 in percentage of fan speed. 16% speed works well for me being quiet enough. See README for more info.
SENSOR_NAME="Temp"
MAX_TEMP="37"

DEC_HEX=$(printf '%x\n' $SET_SPEED)

TEMP=$(ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_UNAME -P $IDRAC_PASSWD sdr type temperature | grep -m 1 "$SENSOR_NAME" | awk '{ print $9 }')

echo "[$DATE] $IDRAC_IP: temp is $TEMP degrees C"
if [[ $TEMP > $MAX_TEMP ]]
  then
    printf "[$DATE] Getting hot in here - enabling dynamic mode"
    ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_UNAME -P $IDRAC_PASSWD raw 0x30 0x30 0x01 0x01
  else
    echo "[$DATE] Temps are less than $MAX_TEMP degrees C ...setting fan speed to $SET_SPEED%"
    ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_UNAME -P $IDRAC_PASSWD raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_UNAME -P $IDRAC_PASSWD raw 0x30 0x30 0x02 0xff 0x$DEC_HEX
    sleep 1
    echo "[Setting applied]"
fi
