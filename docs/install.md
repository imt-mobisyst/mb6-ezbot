# Install instruction : 

At the end, the _mb6-ezbot_ repository aims to be installed on the EzWheel startkit onboard machine.

## Connect the robot :

Connect the robot with _RJ45_ cable and turn-on the robot
You have to configure a fixed ip-adress on your conputer (_PC-Station_) :
> Ip: 192.168.50.1 : 255.255.255.0 : 192.168.50.1

The robot itself is on _192.168.50.2_ with `swd_sk` user name :

```sh
ssh swd_sk@192.168.50.2
```

- Default SSH login: swd_sk
- Default SSH pass: swd_sk

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
```

## Prepare install : 

On your _PC-Station_, set the _ROS_ domaine identifier accordingly to the robot number ($41, 43, \ldots$)
Edit the `ARG ROS_DOMAIN_ID` line in the `ros-humble/Dockerfile`.
Then, configure `ssh` tool and copy the _mb6-ezbot_ directory.

edit ROS_DOMAIN_ID in ~/ros-humble/Dockerfile

```sh
ssh-copy-id swd_sk@192.168.50.2
scp -r . swd_sk@192.168.50.2:mb6-ezbot
```

## Set up docker image : 

Deseable the old `ros-noetic` version :

```sh
ssh swd_sk@192.168.50.2

docker stop ros-noetic
docker update --restart=no ros-noetic 
```

Build the new one whith linked working directories to `mb6-ezbot` version.
On the ezbot side: 

```sh
cd $HOME
ln -s mb6-ezbot/ros-humble
ln -s mb6-ezbot/ros-humble_ws

cd ros-humble 
./rebuild.sh -w ~ -u
```

Do not forget, your _ROS_DOMAIN_ID_ in _~/ros-humble/Dockerfile_ should be corect.

## Memos

<ros_version> = cf. git branch name (humble, ...)

- ```ros-<ros_version>/``` - Dockerfile, scripts, ... to install
    - ```deb/``` - backup ezWheel compiled deb packages
- ```ros-<ros_version>_ws/``` - ROS packages required to control the robot

- Set the wifi down: `sudo ip link set wlan1 down`
- Docker starter: based on _supervisor service_ see: `/etc/supervisor/conf.d/ezw-swd.conf`
