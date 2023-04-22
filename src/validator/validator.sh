#!usr/bin/env bash

out() {
    [[ $1 == "exit" ]] && exit 0
}

validator() {
    [[ $1 == '' ]] && echo "YOU NEED PASS A VALID ARGUMENT" && exit 0
}

validatorHashBroken() {
    [[ $# -eq 0 ]] && echo "YOU NEED SELECT A OPTION" && exit 0
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

existWordListFile() {
    [[ ! -f "$1" ]] && echo "WORDLIST FILE NOT FOUNDED" && exit 0
}

readWordListFile() {
    [[ ! -r "$1" ]] && echo "WORDLIST CAN NOT BE READ, VERIFY PERMISSIONS IN YOUR SISTEM" && exit 0
}

validatorSearchSubdomainOptions(){
    [[ $# -ne 2 ]] && echo "PLEASE INFORM THE CORRECT PARAMS" && exit 0
}