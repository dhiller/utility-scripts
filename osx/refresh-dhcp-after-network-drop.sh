#!/bin/bash

trap "{ exit 0; }" SIGINT SIGTERM

while true; do
  set +e
  ping -t 1 -c 1 -A --apple-time 8.8.8.8 > /dev/null
  result="$?"
  set -e
  if [ $result -ne 0 ]; then
    echo "disabling network interface"
    networksetup -setnetworkserviceenabled Wi-Fi off
    echo "ping failed, renewing dhcp lease"
    sudo ipconfig set en0 DHCP
    sleep 3
    echo "reenabling network interface"
    networksetup -setnetworkserviceenabled Wi-Fi on
    sleep 20
    while true; do
      echo "checking network packet"
      set +e
      ipconfig getpacket en0 > /dev/null
      result="$?"
      set -e
      [ $result -ne 0 ] || break
      sleep 1
    done
    sleep 3
  else
    sleep 3
  fi
done
