#!/bin/bash

usage="$(basename $0) -w <seclist_path> -x [.ext,.ext,.etc] -o [name] -t [thr] -h <http://host>"

# Reset                         
Color_Off='\e[0m'       # Text Reset
                               
# Bold                        
BRed='\e[1;31m'         # Rosso
BGreen='\e[1;32m'       # Verde 

while getopts w:h:x:o:t: option
do
case "${option}"
in
w) seclist_path=${OPTARG};;
h) host=${OPTARG};;
x) ext=${OPTARG};;
o) name=${OPTARG};;
t) thr=${OPTARG};;
esac
done

echo "$seclist_path"
echo "$host"
echo "$ext"
echo "$thr"

[ $# -lt 4 ] && echo "$usage" && exit

[ -n $name ] && name="$name-"
[ -z $thr ] && thr=25

echo -e "${BGreen}[*] Running nikto in background${Color_Off}\n"
echo -e "${BGreen}[*] Check nikto.out file${Color_Off}\n"
/usr/bin/nikto -host "$host" >> nikto.out &

/usr/bin/gobuster -u "$host" -w "$seclist_path/Discovery/Web-Content/common.txt" -t ${thr} -o ${name}common-1 -x "$ext" -s '200,204,301,302,307,401,403'
/usr/bin/gobuster -u "$host" -w "$seclist_path/Discovery/Web-Content/big.txt" -t ${thr} -o ${name}big-1 -x "$ext" -s '200,204,301,302,307,401,403'
/usr/bin/gobuster -u "$host" -w "$seclist_path/Discovery/Web-Content/directory-list-2.3-medium.txt" -t ${thr} -o ${name}dirmed-1 -x "$ext" -s '200,204,301,302,307,401,403'

