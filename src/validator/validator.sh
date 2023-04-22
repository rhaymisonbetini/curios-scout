#!usr/bin/env bash


validatorHashBroken() {
    [[ $# -eq 0 ]] && echo "YOU NEED SELECT A OPTION" && exit 0
}

validatorPortScan() {
    [[ $# -eq 0 ]] && echo "YOU NEED PASS A VALID ARGUMENT TO SCAN" && exit 0
}

validatorSearchSubdomainOptions(){
    [[ $# -ne 2 ]] && echo "PLEASE INFORM THE CORRECT PARAMS" && exit 0
}

validatorParsingHtml(){
    [[ $# -ne 1 ]] && echo "PLASE INFORM THE CORRED DOMAIN OR IP" && exit 0;
}

existWordListFile() {
    [[ ! -f "$1" ]] && echo "WORDLIST FILE NOT FOUNDED" && exit 0
}

readWordListFile() {
    [[ ! -r "$1" ]] && echo "WORDLIST CAN NOT BE READ, VERIFY PERMISSIONS IN YOUR SISTEM" && exit 0
}

validator() {
    [[ $1 == '' ]] && echo "YOU NEED PASS A VALID ARGUMENT" && exit 0
}

validatorHashOptionsAlgo() {
    [[ "$1" == "ALGO" && $2 -eq 1 ]] && echo "YOU NEED PROVIDER A ONE ALGORITHM OPTION" && exit 0
}

validatorHashOptionsWordList() {
    [[ "$1" == "WORDLIST" && $2 -eq 1 ]] && echo "YOU NEED PROVIDER A WORDLIST" && exit 0
}

validatorHashOptionsHash() {
    [[ "$1" == "HASH" && $2 -eq 1 ]] && echo "YOU NEED PROVIDER A HASH" && exit 0
}

out() {
    [[ $1 == "exit" ]] && exit 0
}

existCurl(){
    [[ ! -x "$(which curl)" ]] && sudo apt-get install curl
}

existLynx(){
    [[ ! -x "$(which lynx)" ]] && sudo apt-get install lynx
}