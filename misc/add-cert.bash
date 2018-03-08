#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 hostname"
    exit 1
fi

hostname=$1

echo QUIT \
| openssl s_client -servername $hostname -connect $hostname:443 -showcerts 2>null \
| sed -ne '/BEGIN CERT/,/END CERT/p' \
>/tmp/cert-$hostname

certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n $hostname -i /tmp/cert-$hostname

certutil -d sql:$HOME/.pki/nssdb -L
