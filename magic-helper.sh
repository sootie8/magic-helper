#!/bin/bash
#deps etherwake tcpump
sleep 300;
sleep_timeout=60;
missed_tar=5;
ip_addr="192.168.0.102";
target_subnet="192.168.0.255";
target_mac="64:00:6a:2a:1d:02";
mg_log="/var/log/magic-helper.log";
wake_time=15;
#wol_interface=$(ip link | grep -o "en[^:]*:" | head -c-2);
wol_interface="eth0";
while :
do
	#ping check if 102 is online.
	#if yes sleep, loop.
	back=1;
	last_arp_time=2;
	while [ $last_arp_time -gt $back ]
	do	
		echo $(date -u) " " "target machine is up" | tee -a $mg_log;
		sleep 30;	
		back=$(date '+%s' --date='60 seconds ago');
		last_arp_time=$(tail -n 1 /var/log/log-last-arp.log);
	done
	echo $(date -u) " " "target machine is down" | tee -a $mg_log;
	#if not sleep timeout.
	sleep $sleep_timeout;
	#if arp requests from anywhere -> login
	back=2;
	last_arp_time=1;
	while [ $last_arp_time -lt $back ]
	do
		echo $(date -u) " " "wating for arp" | tee -a $mg_log;
		sleep 1;			
		back=$(date '+%s' --date='60 seconds ago');
		last_arp_time=$(tail -n 1 /var/log/log-last-arp.log);
	done
	#send wol
	echo $(date -u) " " "arp sniffed, sending WOL" | tee -a $mg_log;
	etherwake -i $wol_interface $target_mac -b $target_subnet;			
	sleep $wake_time;
done
