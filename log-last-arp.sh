#!/bin/bash
sleep 300;
while :
do 
	tcpdump 'arp and dst 192.168.0.102' -l -p -i eth0 | while read line ; do date '+%s' > /var/log/log-last-arp.log; done ;
done
