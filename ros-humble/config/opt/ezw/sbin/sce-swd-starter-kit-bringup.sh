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
    ros2 launch swd_starter_kit_bringup starter_kit.launch.py
    #ros2 run swd_ros2_controllers swd_diff_drive_controller --ros-args -p baseline_m:=0.485 
    ;;
"stop")
    kill_all
    ;;
*)
    ;;
esac
