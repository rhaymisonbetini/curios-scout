#!/usr/bin/env bash
clear
source ./src/art.sh
source ./src/validator/validator.sh
source ./src/functions/pingsweep.sh

printf "$HEADERBANNER"

printf "${BBlue} SELECT YOUR CHOICE! \n"

echo "[1] - PINGSWEEP"
read -p "CHOICE: " choice

validator $choice;

case "${choice}" in
1) pingsweep ;;
*) echo "INVALID OPTION!" ;;
esac
