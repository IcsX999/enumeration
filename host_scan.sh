#!/bin/bash

usage="$(basename $0) -a <all|normal> -h <host>"

# Reset                         
Color_Off='\e[0m'       # Text Reset
                               
# Regular Colors               
Black='\e[0;30m'        # Nero 
Red='\e[0;31m'          # Rosso 
Green='\e[0;32m'        # Verde 
Yellow='\e[0;33m'       # Giallo
Blue='\e[0;34m'         # Blu   
Purple='\e[0;35m'       # Viola 
Cyan='\e[0;36m'         # Ciano     
White='\e[0;37m'        # Bianco                    
                         
# Bold                        
BBlack='\e[1;30m'       # Nero 
BRed='\e[1;31m'         # Rosso
BGreen='\e[1;32m'       # Verde 
BYellow='\e[1;33m'      # Giallo
BBlue='\e[1;34m'        # Blu        
BPurple='\e[1;35m'      # Viola
BCyan='\e[1;36m'        # Ciano 
BWhite='\e[1;37m'       # Bianco


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
		echo "${BRed}[!] no TCP ports open${Color_Off}"
		echo "${BRed}[-] try with UDP${Color_Off}"
		/usr/bin/nmap -T5 -sU $host
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
