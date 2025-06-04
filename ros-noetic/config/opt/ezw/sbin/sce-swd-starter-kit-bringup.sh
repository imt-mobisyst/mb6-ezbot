#!/bin/bash

# Set docker environment
[ -s /.dockername ] && source /opt/ezw/install/setup.bash

kill_all() {
    PIDS=$(ps -ef | grep "[/]opt/ros/$ROS_DISTRO" | awk '{print $2}')
    if [ ! -z "$PIDS" ]; then
        kill -9 $PIDS 2>/dev/null
    fi

    PIDS=$(ps -ef | grep "[$HOME]/${DOCKER_NAME}_ws" | awk '{print $2}')
    if [ ! -z "$PIDS" ]; then
        kill -9 $PIDS 2>/dev/null
    fi
}

case "$1" in
"start")
    kill_all
    roslaunch swd_starter_kit_bringup starter_kit.launch 
    ;;
"stop")
    kill_all
    ;;
*)
    ;;
esac
