# Generate the image...

Sur la machine géneratrice, creer un user spécific sur l'uid 1001...

```bash
sudo adduser --uid 1001 swd_sk
sudo usermod -aG docker swd_sk
sudo adduser --uid 1001 swd_sk
```

Avec cette utilisateur...

```bash
su swd_sk
docker build --tag ros-humble:0.1.0 --rm --build-arg NAME=ros-humble --build-arg SWD_UPDATE=$(date '+%s') ./ros-humble
exit

docker save -o dockimg-ros-humble.tar ros-humble:0.1.0
scp dockimg-ros-humble.tar swd_sk@192.169.50.2:
```

Sur l'_Ezbot_: 

```bash
docker load -i ros-humble-docker.tar
# Verifier: docker images
docker run --name ros-humble --restart=always -dti --tmpfs /tmp --shm-size 1g --privileged -v /dev:/dev -v /run/udev:/run/udev:ro -v /dev/input:/dev/input --cap-add=NET_ADMIN -w /home/$USER -v ~:/home/$USER --network=host ros-humble:0.1.0 $USER $USER yes $UID $GID
```

