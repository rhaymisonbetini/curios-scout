#!usr/bin/env bash
HASH_SET=0
HASH=
ALGO_SET=0
ALGO=
WORDLIST_SET=0
WORDLIST=

show_helper() {
    echo -e "Usage: $(basename broken hash) - [OPTIONS]\n
    -h, --help\t\t Show this help menu.
    -H, --hash\t\t Hash to be broken.
    -a, --alg\t\t Receive the type of algorithm to be broken.
    -w, --wordlist\t Receive a wordlist file with possible passwords.

    exemple:

    -h
    -a base64 -h hash => base64 Hash do not need a wordlist to be broken
    -a md5 -H hash - wordlist.txt
    -a sha1 -H hash -wordlist.txt

    Avalible options: base64, md5, sha1, sha256, sha512"
}

define_hash_wordlist() {
    case $1 in
    "ALGO")

        validatorHashOptionsAlgo $1 $ALGO_SET
        local TOTLOWER=$(echo $2 | tr [A-Z] [a-z])
        case "$TOTLOWER" in
        "base64" | "md5" | "sha1" | "sha256" | "sha512")
            ALGO_SET=1
            ALGO="$TOTLOWER"
            ;;
        *) echo "Invalid Algorithm option option" && exit 0 ;;
        esac
        ;;
    "WORDLIST")
        validatorHashOptionsWordList $1 $WORDLIST_SET
        WORDLIST_SET=1
        WORDLIST=$2
        ;;
    "HASH")
        validatorHashOptionsHash $1 $HASH_SET
        HASH_SET=1
        HASH=$2
        ;;
    esac
}

displayPassword(){
    local YELLOW="\033[33;1m"
    echo -e "${YELLOW} The password is =====> $1"
}

cracker_password(){

    if [[ "$ALGO" == "base64" ]]; then
        $BASEPASS="$(echo -n "$HASH" | base64 -d -i)"
        displayPassword $BASEPASS
    else
        existWordListFile $WORDLIST;
        readWordListFile $WORDLIST;

        for PASSWORD in $(cat "$WORDLIST"); do
            local ACTUAL_HASH=$(echo -n $PASSWORD | ${ALGO}sum | tr -d " "-)
            echo "$PASSWORD"
            echo "$ACTUAL_HASH"
            echo "$HASH"
            if [[ "$ACTUAL_HASH" == "$HASH" ]]
            then
                displayPassword $PASSWORD
            fi
        done
    fi
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
        "-a") define_hash_wordlist "ALGO" "${strarr[INDEX + 1]}" ;;
        "-w") define_hash_wordlist "WORDLIST" "${strarr[INDEX + 1]}" ;;
        "-H") define_hash_wordlist "HASH" "${strarr[INDEX + 1]}" ;;
        esac
        INDEX=$(expr $INDEX + 1)
    done

    if [[ $ALGO_SET -eq 1 && $HASH_SET -eq 1 ]]; then
        cracker_password
    else
        show_helper
    fi

}
