#!/usr/bin/env bash
clear
source ./src/art.sh
source ./src/validator/validator.sh
source ./src/functions/pingsweep.sh
source ./src/functions/hashbroken.sh
source ./src/functions/subdomains.sh
source ./src/functions/dirandfiles.sh
source ./src/functions/parsinghtml.sh
source ./src/functions/portscan.sh

printf "$HEADERBANNER"

printf "${BBlue}SELECT YOUR CHOICE! \n"

echo "[1] - PINGSWEEP"
echo "[2] - BROKEN HASH"
echo "[3] - SEARCH FOR SUBDOMAINS"
echo "[4] - SEARCH FOR DIR AND FILES"
echo "[5] - PARSINGHTML"
echo "[6] - PORTSCAN"
read -p "CHOICE: " choice

validator $choice;

case "${choice}" in
1) pingsweep ;;
2) broken_hash ;;
3) search_subdomains ;;
4) dir_and_files ;;
5) parsing_html ;;
6) port_scan ;;
*) echo "INVALID OPTION!" ;;
esac
