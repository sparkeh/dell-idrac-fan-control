### Dell iDRAC fan control with IPMI

This script came from the need to keep a dell T430 server quiet enough in a home office.
The room average temps are about 30 to 34 degrees C with the fan at 16%. No major issues observed and
the server is quiet enough and not as loud as a desktop PC.

Your mileage may vary.

Presently I'm running this script every 5 minutes with a crontab on Ubuntu 18.04 - (see below for cron code)

Setting the `MAX_TEMP` variable will ensure that should the system get too hot, dynamic fan mode will engage. However you will need to use crontab for this. Adjust temp to your liking.

## Installation
These are for Ubuntu

 - You'll need to install `ipmitool`

```
sudo apt install ipmitool
```

 - git clone this repo
 - Append to existing crontab, or make a new one:

```
*/5 * * * * /bin/bash /srv/dell-idrac-fan-control/fan-control.sh
```

Overall this does the job for what I need to do.
It could potentially be extended to leverage SNMP values
on temperature or SNMP traps to change fan speed.
It should be noted that while you can change the speed % of the fan on the iDRAC GUI, this method works for any fan percentage setting.

Tested on iDRAC ver `3.30.30.30`
