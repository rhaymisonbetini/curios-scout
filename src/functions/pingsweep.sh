#!usr/bin/env bash
source ../validator/validator.sh

pingsweep() {
    read -p "INSET THE NETWORK [ex: 192.168.0] :" network
    read -p "DO YOU WANT SAVE PINGSWEEP? [y/n] :" saver

    validator $network
    validator $saver

    for host in $(seq 100 120); do
        PINGER=$(hping3 -S -c 1 $network.$host 2>/dev/null | grep "flags")
        if [[ $PINGER != "" ]]; then
            [[ $saver == "y" ]] && echo "$PINGER" >> pingsweep.txt || echo "$PINGER"
        fi
    done
    echo "PINGSWEEP FINISHED"
    exit 0
}
