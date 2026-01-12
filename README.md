# MobiSyst - BBot

Modified Bibus robot and port for ROS2.

## Network config

Default SSID: SWD-StarterKit-<mac> 
Default password: swd_starterkit
Default IP: 10.10.0.1/24

Edit `/etc/network/interfaces`:
```
auto wlan1
iface wlan1 inet dhcp
	wpa-ssid "IoT IMT Nord Europe"
	wpa-psk "72Hin@R*"
```

Fix IP on IOT using DHCP reservation using http://xxxxx
bbot1 10.120.2.41 (Fatma)
bbot3 10.120.2.43
bbot4 10.120.2.44

Default SSH login: swd_sk
Default SSH pass: swd_sk

docker stop ros-noetic
docker update --restart=no ros-noetic 

## File structure

<ros_version> = cf. git branch name (humble, ...)

- ```ros-<ros_version>/``` - Dockerfile, scripts, ... to install
    - ```deb/``` - backup ezWheel compiled deb packages
- ```ros-<ros_version>_ws/``` - ROS packages required to control the robot

## How to use

```
git clone --recursive --branch ros2-humble git@github.com:imt-mobisyst/pkg-bbot.git
# git submodule update --init --recursive # if you forgot --recusive when cloned

cd $HOME
ln -s pkg-bbot/ros-humble
ln -s pkg-bbot/ros-humble_ws

# edit ROS_DOMAIN_ID in ~/ros-humble/Dockerfile

cd ros-humble
./rebuild.sh -w ~ -u
```

## Links

- https://github.com/IDEC-ezWheel/
- ezWheel ubuntu packages : http://packages.ez-wheel.com:8081/ubuntu/
