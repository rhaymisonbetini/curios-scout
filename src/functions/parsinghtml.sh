#!usr/bin/env bash

parsing_html(){
    read -p "INFORM DOMAIN OR IP TO PARSING: " TARGET
    validatorParsingHtml $TARGET
    existLynx
    lynx -source "$TARGET" | sed "s/ /\n/g" \
    | egrep "href=|action=|src=" \
    | egrep -oh "\"[^\"]*\"|\'[^\']'" \
    | sed "s/\"//g;s/'//g;s/^\/\///" \
    | grep "\." >> parsinghtml.txt
}