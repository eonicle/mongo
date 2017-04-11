#!/bin/bash
MYIP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
IPS=$(arp-scan --interface=eth0 --localnet --numeric --quiet --ignoredups | grep -E '([a-f0-9]{2}:){5}[a-f0-9]{2}' | awk '{print $1}')
for IP in $IPS
do
		IS_MASTER=$(mongo --host $IP --eval "printjson(db.isMaster())" | grep 'ismaster')
    echo $IS_MASTER
		if echo $IS_MASTER | grep "true"
    then
			mongo --host $IP --eval "printjson(rs.add('$MYIP:27017'))"
		fi
done
