#!/usr/scripts/env bash

export LAST_AWESOME_ADDRESS=""

start() {
  CONFIG_FILE=$1
  if [[ -z $CONFIG_FILE ]]; then
    CONFIG_FILE=./rc.lua
  fi
  stop
  ./scripts/awmtt.sh start -W -C $CONFIG_FILE
}

alias restart='./scripts/awmtt.sh restart'

stop() {
  export LAST_AWESOME_ADDRESS=""
  ./scripts/awmtt.sh stop
}

run() {
  ./scripts/awmtt.sh run $1
}

find-awesome-dbus-addresses() {
  DBUS_ADDRESSES=($(dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep -o ':[0-9].[0-9]*'))
  for ADDRESS in "${DBUS_ADDRESSES[@]}"; do
    ./scripts/awesome-client-wrapped --dest $ADDRESS 'return 1 + 1' &>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "%s\n" $ADDRESS
    fi
  done
}

send() {
#  if [[ -z $LAST_AWESOME_ADDRESS ]]; then
    LAST_AWESOME_ADDRESS=$(find-awesome-dbus-addresses | sort -r -t'.' -k 1.1nbr -k 2.1nbr | head -n 1 | tr -d '\n')
#  fi
  if [[ -n $1 ]]; then
    STDIN=$1
  else
    STDIN=$(cat -)
  fi
  ./scripts/awesome-client-wrapped --dest $LAST_AWESOME_ADDRESS "$STDIN"
}

alert() {
    send << __EOF__
    naughty = require("naughty")
    naughty.notify({
	title="CLI Notification",
	text=$@
    })
__EOF__
}


total_number_of_tags() {
    send << EOF

    local all_workspaces = wm:getAllWorkspaces()
    local all_tags = __.flatten(__.map(all_workspaces, function(workspace) return workspace:getAllTags() end))

    naughty = require("naughty")
    naughty.notify({
    title="CLI Notification",
    text="" .. #all_tags})
EOF
}

