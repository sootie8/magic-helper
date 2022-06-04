#!/bin/bash
#deps etherwake tcpump

sleep_timeout=60;
missed_tar=5;
ip_addr="192.168.0.102";
target_subnet="192.168.0.255";
target_mac="64:00:6a:2a:1d:02";
mg_log="/var/log/magic-helper.log";
wake_time=15;
wol_interface=$(ip link | grep -o "en[^:]*:" | head -c-2);
while :
do
	#ping check if 102 is online.
	#if yes sleep, loop.
	ret=0;
	while [ $ret -eq 0 ] 
	do	
		ping $ip_addr -c 1 -W 1;
		ret=$?;
		sleep 5;
		echo $(date -u) " " "target machine is up" | tee -a $mg_log;
	done
	echo $(date -u) " " "target machine is down" | tee -a $mg_log;
	#if not sleep timeout.
	sleep $sleep_timeout;
	#if arp requests from anywhere -> login
	echo $(date -u) " " "wating for arp" | tee -a $mg_log;
	tcpdump 'arp and dst 192.168.0.102' -c 2 -l | tee -a $mg_log;
	#send wol
	echo $(date -u) " " "arp sniffed, sending WOL" | tee -a $mg_log;
	etherwake -i $wol_interface $target_mac -b $target_subnet;			
	sleep $wake_time;
done
