# MobiSyst - BBot

Modified Bibus robot and ROS1 driver.

## File structure

<ros_version> = cf. git branch name (noetic, ...)

- ```ros-<ros_version>/``` - Dockerfile, scripts, ... to install
- ```ros-<ros_version>_ws/``` - ROS packages required to control the robot

## How to use

```
git clone --recursive git@github.com:imt-mobisyst/pkg-bbot.git
# git submodule update --init --recursive # if you forgot --recusive when cloned

cd ros-noetic
./rebuild.sh -h
```

## Links

- https://github.com/IDEC-ezWheel/
- ezWheel ubuntu packages : http://packages.ez-wheel.com:8081/ubuntu/