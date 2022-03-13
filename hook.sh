#!/usr/bin/env bash

export LAST_AWESOME_ADDRESS=""

start() {
  stop
  ./awmtt.sh start -W -C ./rc.lua -S 1280x800
}

alias restart='./awmtt.sh restart'

stop() {
  export LAST_AWESOME_ADDRESS=""
  ./awmtt.sh stop
}

run() {
  ./awmtt.sh run $1
}

find-awesome-dbus-addresses() {
  DBUS_ADDRESSES=($(dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep -o ':[0-9].[0-9]*'))
  for ADDRESS in "${DBUS_ADDRESSES[@]}"; do
    ./awesome-client-wrapped --dest $ADDRESS 'return 1 + 1' &>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "%s\n" $ADDRESS
    fi
  done
}

send() {
  if [[ -z $LAST_AWESOME_ADDRESS ]]; then
    LAST_AWESOME_ADDRESS=$(find-awesome-dbus-addresses | sort -t'.' -k 1.1nbr -k 2.1nbr | head -n 1 | tr -d '\n')
  fi
  if [[ -n $1 ]]; then
    STDIN=$1
  else
    STDIN=$(cat -)
  fi
  ./awesome-client-wrapped --dest $LAST_AWESOME_ADDRESS "$STDIN"
}
