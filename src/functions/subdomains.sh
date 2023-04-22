#!urs/bin/env bash

search_subdomains() {
    read -p "INFORM THE TARGER: " TARGET
    read -p "INFORM WORDLIST: " WORDLIST

    validatorSearchSubdomainOptions $TARGET $WORDLIST

    for SUBDOMAIN in $(cat $WORDLIST); do
        echo "testing for: $SUBDOMAIN.$TARGET"
        host $SUBDOMAIN.$TARGET | grep "has address" >>"subdomains.txt"
    done

    if test -f "subdomains.txt"; then
        cat subdomains.txt | sort -u | sed "s/has address/===>"
        else
        echo "NO SUBDOMAINS FOUNDED"
    fi

}
