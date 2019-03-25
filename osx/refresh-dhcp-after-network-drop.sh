#!/bin/bash

function usage {
  cat <<HERE
${0##*/}

Monitors network connection, resets network and refreshes DHCP lease if failure occurs
Accepts a password for use by sudo as parameter, however also evaluates environment variable REFRESH_DHCP_SUDO_PWD if set.

usage: ${0##*/} [<sudo_password>]
HERE
}

function announce_sleep {
  local duration_seconds="$1"; shift
  [ ! -z "$VERBOSE" ] && echo "sleeping for $duration_seconds seconds"
  sleep $duration_seconds
}

function ping_dns {
  set +e
  ping -t 1 -c 1 -A --apple-time 8.8.8.8 > /dev/null
  result="$?"
  set -e
  echo $result
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  usage
  exit 0
fi

if [ "$1" == "-v" ] || [ "$1" == "--verbose" ]; then
  VERBOSE="yes"
  shift
fi

if [ $# -gt 0 ]; then
  echo "using argument as sudo password"
  password="$1"; shift
else
  if [ ! -z "$REFRESH_DHCP_SUDO_PWD" ]; then
    echo "using password set by env var"
    password="$REFRESH_DHCP_SUDO_PWD"
  fi
fi

trap "{ exit 0; }" SIGINT SIGTERM

network_resets=0
while true; do
  result=$(ping_dns)
  if [ $result -ne 0 ]; then
    [ ! -z "$VERBOSE" ] && echo "ping failed, assuming network connection down." || clear; echo "network down, waiting to come up again..."
    [ ! -z "$VERBOSE" ] && echo "disabling network interface..."
    networksetup -setnetworkserviceenabled Wi-Fi off
    [ ! -z "$VERBOSE" ] && echo "renewing dhcp lease..."
    if [ ! -z $password ]; then
      echo "$password" | sudo -S ipconfig set en0 DHCP
    else
      sudo ipconfig set en0 DHCP
    fi
    announce_sleep 3
    [ ! -z "$VERBOSE" ] && echo "reenabling network interface..."
    networksetup -setnetworkserviceenabled Wi-Fi on
    announce_sleep 5
    ((network_resets++))
    retries=3
    sleep_increase=2
    sleep_duration=2
    while [ $retries -gt 0 ]; do
      announce_sleep "$sleep_duration"
      [ ! -z "$VERBOSE" ] && echo "checking network packet"
      set +e
      ipconfig getpacket en0 > /dev/null
      result="$?"
      set -e
      if [ $result -eq 0 ]; then
        result=$(ping_dns)
        [ ! -z "$VERBOSE" ] && echo "pinging dns"
        if [ $result -eq 0 ]; then
          [ ! -z "$VERBOSE" ] && echo "success!"
          break
        fi
      fi
      sleep_duration=$((sleep_duration + sleep_increase))
      ((sleep_increase++))
      ((retries--))
    done
  else
    clear
    echo "network connection is alive ($network_resets network resets done)"
    sleep 3
  fi
done
