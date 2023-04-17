#!usr/bin/env bash

validator(){
    [[ $1 == '' ]] && echo "YOU NEED PASS A VALID ARGUMENT" && exit 0
}