# MobiSyst - BBot

Modified Bibus robot and port for ROS2.

## File structure

<ros_version> = cf. git branch name (humble, ...)

- ```ros-<ros_version>/``` - Dockerfile, scripts, ... to install
    - ```deb/``` - backup ezWheel compiled deb packages
- ```ros-<ros_version>_ws/``` - ROS packages required to control the robot

## How to use

```
git clone --recursive --branch ros2-humble git@github.com:imt-mobisyst/pkg-bbot.git
# git submodule update --init --recursive # if you forgot --recusive when cloned

cd pkg-bbot/ros-humble
./rebuild.sh -h
```

## Links

- https://github.com/IDEC-ezWheel/
- ezWheel ubuntu packages : http://packages.ez-wheel.com:8081/ubuntu/
