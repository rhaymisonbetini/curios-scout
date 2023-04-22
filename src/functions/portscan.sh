#!usr/bin/env bash

TARGET_SET=0
TARGET_TYPE=
TARGET=
TARGET_FILE="/tmp/hosts-$$.txt"

FIRST_PORT=
LAST_PORT=
PORTS_FILE="/tmp/ports-$$.txt"
PORTS_OPEN_FILE="/tmp/ports-open-$$.txt"

declare -a NETWORK_ARRAY
NETWORK_DOTS=

VERMELHO="\033[31;1m"
YELLOW='\033[33;1m'
BLUE='\033[34;1m'
END='\033[m'

show_port_scan_helper() {
    echo -e "Usage: [OPTIONS]\n
     -h, --help\t\t\t Show this menu.
     -H, --host\t\t\t Receive a URL or IP.
     -f, --file\t\t\t Receive a file with a list of hosts or ips.
     -n, --network\t\t Receive a network.
     -p, --port\t\t\t Receive a port or a port range.

     Exemplo:

     $0 -h
     $0 -H www.site.com -p 80
     $0 -H 192.168.0.1 -p 22:80 ==> RANGE [FIRST_PORT:LAST_PORT]
     $0 -f hosts.txt -p 23,25,53,80
     $0 -n 192.168.0 -p 443
    "
}

verify_file_exists() {

    if [[ ! -f "$1" ]]; then
        echo -e "\n${VERMELHO}Erro! Host file not founded! Verify the path.\n" && exit 1
    elif [[ ! -r "$1" ]]; then
        echo -e "\n${VERMELHO}Erro! Host file do not have read permission. \n" && exit 1
    fi
}

verify_target() {

    if [[ $TARGET_SET -eq 1 ]]; then
        show_alert_target
    else
        TARGET_SET=1
        TARGET_TYPE="$1"
        TARGET="$2"

        if [[ "$TARGET_TYPE" = "FILE" ]]; then

            verify_file_exists "$TARGET"

            cp "$TARGET" "$TARGET_FILE"

        elif [[ "$TARGET_TYPE" = "HOST" ]]; then

            echo "$TARGET" >>"$TARGET_FILE"

        elif [[ "$TARGET_TYPE" = "NETWORK" ]]; then
            NETWORK_ARRAY=($(echo $TARGET | tr . " "))

            NETWORK_DOTS=$(echo $TARGET | tr -cd . | wc -c)

            if [[ ${#NETWORK_ARRAY[@]} -gt 3 || $NETWORK_DOTS -gt 2 ]]; then
                echo -e "\n${VERMELHO}Erro! Rede inválida!\n" && exit 1
            else
                for host in $(seq 1 254); do
                    echo $TARGET.$host >>"$TARGET_FILE"
                done
            fi
        fi

        if [[ $(cat "$TARGET_FILE" | wc -m) -eq 0 ]]; then
            echo -e "\n${VERMELHO}Erro! No host to scan. \n"
            exit 1
        fi
    fi
}

reverse_ports() {

    if [[ $1 -gt $2 ]]; then
        FIRST_PORT=$2
        LAST_PORT=$1
    fi
}

verify_port_number() {

    if [[ $1 -lt 1 || $1 -gt 65535 ]]; then
        echo -e "\n${VERMELHO}Erro! Inform a port between 1 e 65535!\n"

        exit 1
    fi
}

verify_port() {

    if [[ $(echo "$1" | grep -c ,) -eq 1 ]]; then

        for port in $(echo "$1" | tr , " "); do
            verify_port_number $port
            echo $port >>"$PORTS_FILE"
        done

    else

        FIRST_PORT="$(echo $1 | cut -d : -f 1)"
        LAST_PORT="$(echo $1 | cut -d : -f 2)"

        verify_port_number $FIRST_PORT
        verify_port_number $LAST_PORT

        reverse_ports $FIRST_PORT $LAST_PORT

        seq $FIRST_PORT $LAST_PORT >>"$PORTS_FILE"
    fi

}

show_ports_open() {

    if [[ -f "$PORTS_OPEN_FILE" ]]; then
        echo
        echo -e "${YELLOW}######################${END}"
        echo -e "${YELLOW}#  HOST $1${END}"
        echo -e "${YELLOW}######################${END}"

        for port in $(cat $PORTS_OPEN_FILE); do
            echo -e "${YELLOW}#  PORT $port OPEN!${END}"
        done

        echo -e "${YELLOW}######################${END}"

        rm -rf "$PORTS_OPEN_FILE"
    fi
}

go_portscan() {

    local RETURN_HPING

    for host in $(cat $TARGET_FILE); do

        for port in $(cat $PORTS_FILE); do
            echo "SCANING NOW $port $host"
            RETURN_HPING="$(sudo hping3 --syn -c 1 -p $port $host 2>/dev/null | grep "flags=SA" | cut -d " " -f 2 | cut -d "=" -f 2)"
            [[ "$RETURN_HPING" != "" ]] && echo $port >>"$PORTS_OPEN_FILE"
        done
        show_ports_open "$host"
    done

    echo
}

show_alert_target() {

    echo -e "\n${VERMELHO}Erro! You must provide a host, file host or network. \n" && exit 1
}

port_scan() {
    show_port_scan_helper

    read -p "LETS SCAN !! :" comand
    IFS=' ' read -a strarr <<<"$comand"
    validatorPortScan $comand

    INDEX=0

    for val in "${strarr[@]}"; do
        case "$val" in
        "-h") show_helper && exit 0 ;;
        "-H") verify_target "HOST" "${strarr[INDEX + 1]}" ;;
        "-f") verify_target "FILE" "${strarr[INDEX + 1]}" ;;
        "-n") verify_target "NETWORK" "${strarr[INDEX + 1]}" ;;
        "-p") verify_port "${strarr[INDEX + 1]}" ;;
        esac
        INDEX=$(expr $INDEX + 1)
    done

    if [[ $TARGET_SET -eq 1 ]]; then
        go_portscan
    else
        show_alert_target
    fi
}
