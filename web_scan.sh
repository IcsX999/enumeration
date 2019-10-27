#!/bin/bash

read -p "[*] Host: " host
read -p "[*] Seclist path: " seclist_path
read -p "[*] Extentions:" ext

/usr/bin/gobuster dir -u "$host" -w "$seclist_path/Discovery/Web-Content/common.txt" -t 25 -o common-1 -x "$ext"
/usr/bin/gobuster dir -u "$host" -w "$seclist_path/Discovery/Web-Content/big.txt" -t 25 -o big-1 -x "$ext"
/usr/bin/gobuster dir -u "$host" -w "$seclist_path/Discovery/Web-Content/directory-list-2.3-medium.txt" -t 25 -o dirmed-1 -x "$ext"

/usr/bin/nikto -host $host
