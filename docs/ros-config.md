# IMT-MobySyst Configuration :

The _starter_kit_ bringup is based on a the `starter_kit.launch.py` launch file in the `swd_starter_kit_bringup` ROS2 package installed in the `pkg-bbot/ros-humble_ws` workspace.
The startegy is mainly to replace this launch file, the old one is saved as `starter_kit_default`.

In facts, `Starter_kit_mb6` introduces a multiplexer, our parasit from our basic package and a specific joystic configuration.

```sh
docker exec -it -u swd_sk ros-humble bash

#sudo chown -R swd_sk:swd_sk install
# Clone basic packages
cd pkg-bbot/ros-humble_ws/src
git submodule add git@github.com:imt-mobisyst/pkg-basic
git submodule add git@github.com:imt-mobisyst/pkg-multibot

# Get updated launch file
cd ../swd_starter_kit_bringup/launch
cp starter_kit.launch.py starter_kit_default.launch.py
scp bot@192.168.50.1:mb6-space/launch/swd_starter_kit_mb6.launch.py .
cp swd_starter_kit_mb6.launch.py starter_kit.launch.py

cd
cd pkg-bbot/ros-humble_ws
colcon build
/opt/ezw/sbin/sce-swd-starter-kit-bringup.sh start
```

