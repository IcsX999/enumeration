#!/bin/bash

read -p "ip: " ip
out=$(/usr/bin/nmap -T5 -p- -oN all-1 $ip)
ports=$(echo "$out" |grep open |awk -F/ '{print $1}' |tr '\n' ',' |sed s'/.$//')
if [ -z $ports ]
then
	echo "[!] no TCP ports open"
	echo "[-] try with UDP"
	/usr/bin/nmap -T5 -sU $ip
else
	/usr/bin/nmap -T5 -p${ports} -sC -sV -oN vers-1 $ip
	/usr/bin/nmap -T5 -p${ports} --script=vuln -oN vuln-1 $ip
fi
