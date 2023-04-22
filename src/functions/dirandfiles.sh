#!usr/bin/env bash

show_helper_dir_files() {
    echo -e "Usage: $(basename broken hash) - [OPTIONS]\n
    -h, --help\t\t Show this help menu.
    -e, --extension\t Receive extensions of the possible files.

    exemple:

    -h
    -e www.site.com wordlist.txt -e txt,php,zip,jpeg,png,gif"

}

do_request(){
    curl -s -o /dev/null -w "%{http_code}" -L -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59" "$1"
}

find_files(){
    STATUSFILE=0
    for EXTEN in "${array[@]}"
    do
        echo "Looking for $1/$2.$EXTEN"
        STATUSFILE=$(do_request "$1/$2.$EXTEN")
        if [[  $STATUSFILE -eq 200 ]]
        then 
            echo "SUCCESS TO FIND FILES: $1/$2.$EXTEN"
        fi
    done
}

dir_and_files() {
    show_helper_dir_files

    read -p "TELL ME THE TARGET WITH WORDLIST AND EXTENSIONS! :" comand
    IFS=' ' read -a strarr <<<"$comand"

    validatorHashBroken $comand

    HOST=${strarr[0]}
    WORDLIST=${strarr[1]}
    EXT=${strarr[3]}
    TOTALFILES=0
    if [[ $EXT == " " ]]; then
        echo "NO EXTENSIONS PASSED"
        exit 0
    fi

    existWordListFile $WORDLIST
    existCurl

    STATUS=0
    IFS=',()][' read -r -a array <<<"$(echo $EXT)"
    for dir in $(cat $WORDLIST); do
        echo "Looking for $HOST/$dir"
        STATUS=$(do_request "$HOST/$dir")
        if [[  STATUS -eq 200 ]]
        then 
            echo "SUCCESS: $HOST/$dir" 
        fi
        [[ ${#array[@]} -gt 0 ]] && find_files $HOST "$dir" 
    done
}
