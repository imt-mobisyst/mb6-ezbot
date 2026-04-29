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


# IMT-MobySyst Configuration :

The _starter_kit_ bringup is based on a the `starter_kit.launch.py` launch file in the `swd_starter_kit_bringup` ROS2 package installed in the `mb6-ezbot/ros-humble_ws` workspace.
The startegy is mainly to replace this launch file, the old one is saved as `starter_kit_default`.

In facts, `Starter_kit_mb6` introduces a multiplexer, our parasit from our basic package and a specific joystic configuration.

To notice that, modifications do not require for docker image rebuilt...

```sh
docker exec -it -u swd_sk ros-humble bash
# Clone basic packages
cd mb6-ezbot
git pull
cd ros-humble_ws
sudo chown -R swd_sk:swd_sk install
colcon build
/opt/ezw/sbin/sce-swd-starter-kit-bringup.sh start
```


## Links

- [Ezbot entrance point](https://imt-mobisyst.github.io/mb6-space/robot-ezbot)
- [EzWheel github group](https://github.com/IDEC-ezWheel)
- [EzWheel ubuntu packages](http://packages.ez-wheel.com:8081/ubuntu)
