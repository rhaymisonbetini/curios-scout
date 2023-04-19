#!usr/bin/env bash

validator(){
    [[ $1 == '' ]] && echo "YOU NEED PASS A VALID ARGUMENT" && exit 0
}

validatorHashBroken(){
    [[ $# -eq 0 ]] && echo "YOU NEED SELECT A OPTION" && exit 0
}

validatorHashOptionsAlgo(){
    [[ "$1" == "ALGO" && $2 -eq 1   ]] && echo "YOU CAN PASS A ONE ALGORITHM OPTION" && exit 0;
}