#!/usr/bin/env bash
clear
source ./src/art.sh
source ./src/validator/validator.sh
source ./src/functions/pingsweep.sh
source ./src/functions/hashbroken.sh

printf "$HEADERBANNER"

printf "${BBlue}SELECT YOUR CHOICE! \n"

echo "[1] - PINGSWEEP"
echo "[2] - BROKEN HASH"
read -p "CHOICE: " choice

validator $choice;

case "${choice}" in
1) pingsweep ;;
2) broken_hash ;;
*) echo "INVALID OPTION!" ;;
esac
