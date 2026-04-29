# Install instruction : 

At the end, the _mb6-ezbot_ repository aims to be installed on the EzWheel startkit onboard machine.

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

Fix IP on IOT using DHCP reservation using [local dhcp interface](http://10.120.2.8:3000)

```
ezbot41 10.120.2.41 (Fatma)
ezbot43 10.120.2.43
ezbot44 10.120.2.44

Default SSH login: swd_sk
Default SSH pass: swd_sk
```

## Deseable old version

```sh
docker stop ros-noetic
docker update --restart=no ros-noetic 
```

## Deseable old version

```sh
docker stop ros-noetic
docker update --restart=no ros-noetic 
```


## How to use

```sh
git clone --recursive --branch ros2-humble git@github.com:imt-mobisyst/mb6-ezbot.git
# git submodule update --init --recursive # if you forgot --recusive when cloned

cd $HOME
ln -s mb6-ezbot/ros-humble
ln -s mb6-ezbot/ros-humble_ws

# edit ROS_DOMAIN_ID in ~/ros-humble/Dockerfile

cd ros-humble
./rebuild.sh -w ~ -u
```





## Memos

<ros_version> = cf. git branch name (humble, ...)

- ```ros-<ros_version>/``` - Dockerfile, scripts, ... to install
    - ```deb/``` - backup ezWheel compiled deb packages
- ```ros-<ros_version>_ws/``` - ROS packages required to control the robot

