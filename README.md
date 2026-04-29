# MobiSyst - Ezbot robot

Modified EzWheel starterkit robot for IMT Nord-Europe use.

Main modifications: 

- Port to ROS2 - humble.
- Specific launch configuration
- Integretion of _Multiplexer Node_
- Integration of multi-robot package.

## Install

Shoul be cloned recursivelly.

```sh
cd
git clone --recursive --branch ros2-humble git@github.com:imt-mobisyst/mb6-ezbot.git
# git submodule update --init --recursive # if you forgot --recusive when cloned
```

For _Ezbot machine_ instructions, go on [docs/install.md](./docs/install.md)


## Links

- [Ezbot entrance point](https://imt-mobisyst.github.io/mb6-space/robot-ezbot)
- [EzWheel github group](https://github.com/IDEC-ezWheel)
- [EzWheel ubuntu packages](http://packages.ez-wheel.com:8081/ubuntu)
