#!/bin/bash

function announce_sleep {
  local duration_seconds="$1"; shift
  echo "sleeping for $duration_seconds seconds"
  sleep $duration_seconds
}

function ping_dns {
  set +e
  ping -t 1 -c 1 -A --apple-time 8.8.8.8 > /dev/null
  result="$?"
  set -e
  echo $result
}

trap "{ exit 0; }" SIGINT SIGTERM

while true; do
  result=$(ping_dns)
  if [ $result -ne 0 ]; then
    echo "ping failed, assuming network connection down."
    echo "disabling network interface..."
    networksetup -setnetworkserviceenabled Wi-Fi off
    echo "renewing dhcp lease..."
    sudo ipconfig set en0 DHCP
    announce_sleep 3
    echo "reenabling network interface..."
    networksetup -setnetworkserviceenabled Wi-Fi on
    announce_sleep 5
    retries=5
    while [ $retries -gt 0 ]; do
      echo "checking network packet"
      set +e
      ipconfig getpacket en0 > /dev/null
      result="$?"
      set -e
      if [ $result -eq 0 ]; then
        result=$(ping_dns)
        echo "pinging dns"
        if [ $result -eq 0 ]; then
          echo "success!"
          break
        fi
      fi
      announce_sleep 3
      ((retries--))
    done
  else
    sleep 3
  fi
done
