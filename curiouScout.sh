#!/usr/bin/env bash
clear
source ./src/art.sh
source ./src/validator/validator.sh
source ./src/functions/pingsweep.sh
source ./src/functions/hashbroken.sh
source ./src/functions/subdomains.sh
source ./src/functions/dirandfiles.sh

printf "$HEADERBANNER"

printf "${BBlue}SELECT YOUR CHOICE! \n"

echo "[1] - PINGSWEEP"
echo "[2] - BROKEN HASH"
echo "[3] - SEARCH FOR SUBDOMAINS"
echo "[4] - SEARCH FOR DIR AND FILES"
read -p "CHOICE: " choice

validator $choice;

case "${choice}" in
1) pingsweep ;;
2) broken_hash ;;
3) search_subdomains ;;
4) dir_and_files ;;
*) echo "INVALID OPTION!" ;;
esac
