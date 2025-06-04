#!/usr/bin/env bash

function source_file() {
    local status=""
    if [ -f "$1" ]; then
        source "$1" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            status="SUCCESS"
        else
            status="FAILURE"
        fi
    else
        status="IGNORE "
    fi

    echo "[$status] source $1"
}

if [ -s /.dockername ]; then
    # Load docker environment
    source /.dockername

    if [ -n $TERM ]; then
        # Set prompt
        nb_colors=$(infocmp | grep colors | grep -oE 'colors#[0-9]+' | grep -oE '[0-9]+') # nb_colors=$(tput colors)
        if [ ! -z "$nb_colors" ] && [ "$nb_colors" -gt "2" ]; then
            [[ -z $(echo $PS1 | hexdump | grep "9ff0 b390") ]] && PS1="🐳 \[\033[36m\][$DOCKER_NAME]\[\[\033[m\] $PS1"
        else
            [[ -z $(echo $PS1 | grep "$DOCKER_NAME") ]] && PS1="[$DOCKER_NAME] $PS1"
        fi
    fi

    # Set prompt
#    nb_colors=$(infocmp | grep colors | grep -oE 'colors#[0-9]+' | grep -oE '[0-9]+') # nb_colors=$(tput colors)
#    if [ ! -z "$nb_colors" ] && [ "$nb_colors" -gt "2" ]; then
#        [[ -z $(echo $PS1 | hexdump | grep "9ff0 b390") ]] && PS1="🐳 \[\033[36m\][$DOCKER_NAME]\[\[\033[m\] $PS1"
#    else
#        [[ -z $(echo $PS1 | grep "$DOCKER_NAME") ]] && PS1="[$DOCKER_NAME] $PS1"
#    fi

    # Load system ROS workspace environment
    source_file "/opt/ros/$ROS_DISTRO/setup.bash"

    # Load user ROS workspace environment
    source_file "/home/${USER_NAME}/${DOCKER_NAME}_ws/install/setup.bash"

    # Set ezw library path
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ezw/usr/lib

    # Load DBus session
    export $(cat /tmp/SYSTEMCTL_dbus.id)

    # Load user environment
    source_file /home/${USER_NAME}/setup.bash
fi
