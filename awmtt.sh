#!/usr/bin/env bash
# awmtt: awesomewm testing tool
# https://github.com/mikar/awmtt

#{{{ Usage
usage() {
    cat <<EOF
awmtt start [-B <path>] [-C <path>] [-D <int>] [-S <size>] [-a <opt>]... [-x <opts>]
awmtt (stop [all] | restart)
awmtt run [-D <int>] <command>

Arguments:
  start           Spawn nested Awesome via Xephyr
  stop            Stop all instances of Xephyr
  restart         Restart all instances of Xephyr
  run <cmd>       Run a command inside a Xephyr instance (specify which one with -D)

Options:
  -B|--binary <path>  Specify path to awesome binary (for testing custom awesome builds)
  -C|--config <path>  Specify configuration file
  -D|--display <int>  Specify the display to use (e.g. 1)
  -W|--watch          Watch all lua files recursively from current directory
  -N|--notest         Don't use a testfile but your actual rc.lua (i.e. $HOME/.config/awesome/rc.lua)
                      This happens by default if there is no rc.lua.test file.
  -S|--size <size>    Specify the window size
  -a|--aopt <opt>     Pass option to awesome binary (e.g. --no-argb or --check). Can be repeated.
  -x|--xopts <opts>   Pass options to xephyr binary (e.g. -keybd ephyr,,,xkblayout=de). Needs to be last.
  -h|--help           Show this help text and exit
  
Examples:
  awmtt start (uses defaults: -C $HOME/.config/awesome/rc.lua.test -D 1 -S 1024x640)
  awmtt start -C /etc/xdg/awesome/rc.lua -D 3 -S 1280x800
EOF
    exit 0
}
[ "$#" -lt 1 ] && usage
#}}}

#{{{ Utilities
errorout() { echo "error: $*" >&2; exit 1; }
#}}}

#{{{ Executable check
AWESOME=$(which awesome)
XEPHYR=$(which Xephyr)
ENTR=$(which entr)
[[ -x "$AWESOME" ]] || errorout 'Please install Awesome first'
[[ -x "$XEPHYR" ]] || errorout 'Please install Xephyr first'
[[ -x "$ENTR" ]] || errorout 'Please install entr first'
#}}}

#{{{ Default Variables
# Display and window size
D=1
WATCH=0
SIZE="1024x640"
AWESOME_OPTIONS=""
XEPHYR_OPTIONS=""
# Path to rc.lua
if [[ "$XDG_CONFIG_HOME" ]]; then
    RC_FILE="$XDG_CONFIG_HOME"/awesome/rc.lua.test
else
    RC_FILE="$HOME"/.config/awesome/rc.lua.test
fi
[[ ! -f "$RC_FILE" ]] && RC_FILE="$HOME"/.config/awesome/rc.lua
#}}}

#{{{ Functions
#{{{ Start function
start() {

#  if the select select display is unavailable
  if [[ -f "/tmp/.X11-unix/X${D}" ]]; then
    echo "speficied display ${D} unavailable... Searching for display"
      # check for free $DISPLAYs
      for ((i=1;;i++)); do
          if [[ ! -f "/tmp/.X11-unix/X${i}" ]]; then
              D=$i;
              echo "Using display ${D}"
              break;
          fi;
      done
    fi
    
    "$XEPHYR" :$D -name xephyr_$D -ac -br -noreset -resizeable -screen "$SIZE" $XEPHYR_OPTIONS 2> /dev/null &
    XEPHYR_PID=$!

    # Need to wait for Xehpyr display to become available
    while [ ! -e /tmp/.X11-unix/X${D} ] ; do
        sleep 0.1
    done

    DISPLAY=:$D.0 "$AWESOME" --config "$RC_FILE" --search lua_modules/ $AWESOME_OPTIONS &
    WM_PID=$!

#     watch files for changes and send sighup to awesome instance
    if [[ $WATCH -eq 1 ]]; then
      find $BASE_DIRECTORY -type f -name "*.lua" | entr -pn kill -HUP $WM_PID 2> /dev/null &
      echo "watching"
    fi

    # print some useful info
    if [[ "$RC_FILE" =~ .test$ ]]; then
    echo "Using a test file ($RC_FILE)"
    else
    echo "Caution: NOT using a test file ($RC_FILE)"
    fi

    echo "Display: $D, Awesome PID: $WM_PID, Xephyr PID: $XEPHYR_PID"
}
#}}}

#{{{ Stop function
stop() {
    pgrep -f Xephyr | xargs -I{} kill -INT {}
    pgrep -f entr | xargs -I{} kill -INT {}
}
#}}}

#{{{ Restart function
restart() {
    # TODO: (maybe use /tmp/.X{i}-lock files) Find a way to uniquely identify an awesome instance
    # (without storing the PID in a file). Until then all instances spawned by this script are restarted...
    echo -n "Restarting Awesome... "

    for i in $(pgrep -f "awesome --config"); do
        kill -s SIGHUP $i;
    done
}
#}}}
#{{{ Run function
run() {
    [[ -z "$D" ]] && D=1
    DISPLAY=:$D.0 "$@" &
    LASTPID=$!
    echo "PID is $LASTPID"
}
#}}}

#{{{ Parse options
parse_options() {
    while [[ -n "$1" ]]; do
        case "$1" in
            start)          input=start;;
            stop)           input=stop;;
            restart)        input=restart;;
            run)            input=run;;
            -B|--binary)    shift; AWESOME="$1";;
            -C|--config)    shift; RC_FILE="$1";;
            -D|--display)   shift; D="$1"
                            [[ ! "$D" =~ ^[0-9] ]] && errorout "$D is not a valid display number";;
            -W|--watch)     WATCH=1;;
            -N|--notest)    RC_FILE="$HOME"/.config/awesome/rc.lua;;
            -S|--size)      shift; SIZE="$1";;
            -a|--aopt)      shift; AWESOME_OPTIONS+="$1";;
            -x|--xopts)     shift; XEPHYR_OPTIONS="$@";;
            -h|--help)      usage;;
            *)              args+=("$1");;
        esac
        shift
    done
}
#}}}
#}}}

#{{{ Main 
main() {
    case "$input" in
        start)    start "${args[@]}";;
        stop)     stop "${args[@]}";;
        restart)  restart "${args[@]}";;
        run)      run "${args[@]}";;
        *)        echo "Option missing or not recognized";;
    esac
}
#}}}

parse_options "$@"
main
