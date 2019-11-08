#!/bin/bash

usage="$(basename $0) -a <all|normal> -h <host>"

# Reset                         
Color_Off='\e[0m'       # Text Reset
                               
# Bold                        
BRed='\e[1;31m'         # Rosso
BGreen='\e[1;32m'       # Verde 

while getopts a:h: option
do
case "${option}"
in
a) action=${OPTARG};;
h) host=${OPTARG};;
esac
done

[ $# -lt 4 ] && echo "$usage" && exit

scan () {
	ports=$(echo "$out" |grep open |awk -F/ '{print $1}' |tr '\n' ',' |sed s'/.$//')
	if [ -z $ports ]
	then
		echo -e "${BRed}[!] no TCP ports open${Color_Off}"
		echo -e "${BRed}[-] try with UDP${Color_Off}"
		/usr/bin/sudo usr/bin/nmap -T5 -sU $host
	else
		echo -e "${BGreen}[*] Starting NMAP Service Version Scan${Color_Off}\n"
		/usr/bin/nmap -T5 -p${ports} -sC -sV -oN vers-1 $host
		echo -e "\n${BGreen}[*] Starting NMAP Service vulnerabilities${Color_Off}\n"
		/usr/bin/nmap -T5 -p${ports} --script=vuln -oN vuln-1 $host
	fi
}

if [ $action == "all" ];then
	echo -e "${BGreen}[*] NMAP all tcp scan${Color_Off}\n"
	out=$(/usr/bin/nmap -p- -T5 -oN all-1 $host)
	scan
elif [ $action == "normal" ];then
	echo -e "${BGreen}[*] NMAP normal tcp scan${Color_Off}\n"
	out=$(/usr/bin/nmap -T5 -oN nmap-1 $host)
	scan
fi
echo -e "\n${BGreen}[+] FINE${Color_Off}\n"
