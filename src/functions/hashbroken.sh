#!usr/bin/env bash

source ../validator/validator.sh

HASH_SET=0
HASH=
ALGO_SET=0
ALGO=
WORDLIST_SET=0
WORDLIST=

show_helper() {
    echo -e "Usage: $(basename broken hash) - [OPTIONS]\n
    -h, --help\t\t Show this help menu.
    -H, --hash\t\t tHash to be broken.
    -a, --alg\t\t Receive the type of algorithm to be broken.
    -w, --wordlis\t tReceive a word list file with possible passwords.

    exemple:

    -h
    -a base64 -h hash => base64 Hash do not need a word list to be broken
    -a md5 -H hash - wordlist.txt
    -a sha1 -H hash -wordlist.txt

    Avalible options: base64, md5, sha1, sha256, sha512"
}

define_hash_wordlist(){
   validatorHashOptionsAlgo $1 $ALGO_SET
    case $1 in
        "ALGO")
            local TOTLOWER=$(echo $2 | tr [A-Z] [a-z])
            case "$TOTLOWER" in
                "base64"|"md5"|"sha1"|"sha256"|"sha512")
                    ALGO_SET=1
                    ALGO="$TOTLOWER"
                ;;
                *) echo "Invalid Algorithm option option" && exit 0;;
            esac
    esac
}

broken_hash() {
    show_helper

    read -p "GIVE ME A HASH! :" comand
    IFS=' ' read -a strarr <<<"$comand"
    
    validatorHashBroken "$strarr"

    INDEX=0
    for val in "${strarr[@]}"; do
        case "$val" in
            "-h") show_helper && exit 0 ;;
            "-a") define_hash_wordlist "ALGO" "${strarr[INDEX + 1]}"  ;;
            "-w") define_hash_wordlist "WORDLIST" "${strarr[INDEX + 1]}"  ;;
            "-H") define_hash_wordlist "HASH" "${strarr[INDEX + 1]}"  ;;
        esac
        INDEX=$(expr $INDEX + 1)
    done
}
