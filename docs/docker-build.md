# Generate the image...

Sur la machine géneratrice:

```bash
docker build --tag ros-humble:0.1.0 --rm --build-arg NAME=ros-humble --build-arg SWD_UPDATE=$(date '+%s') .
docker save -o ros-humble-docker.tar ros-humble:0.1.0
scp ros-humble-docker.tar swd_sk@192.169.50.2:
```

Sur l'_Ezbot_: 

```bash
docker load -i ros-humble-docker.tar
# Verifier: docker images
docker run --name ros-humble --restart=always -dti --tmpfs /tmp --shm-size 1g --privileged -v /dev:/dev -v /run/udev:/run/udev:ro -v /dev/input:/dev/input --cap-add=NET_ADMIN -w /home/$USER -v ~:/home/$USER --network=host ros-humble:0.1.0 $USER $USER yes $UID $GID
```

