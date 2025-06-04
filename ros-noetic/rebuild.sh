#!/bin/bash

VERSION=$(cat changelog | grep -m1 'urgency' | sed 's/^.* (//' | sed 's/) .*$//')

NAME=ros
SUFFIX=noetic
UBUNTU=20.04

help() {
  echo "Usage: rebuild.sh -w <WORKSPACE_DIR>"
  echo "  arguments:"
  echo "    -w, --workspace <WORKSPACE_DIR>"
  echo "                        The directory on the host used to mount the home directory into the container."
  echo "                        ie : ~ or ~/sandbox"
  echo "  optional arguments:"
  echo "    -h, --help            show this help message and exit"
  echo "    -u, --swd-update      force SWD packages update"
  echo "    -U, --ubuntu-update   force Ubuntu image update"
  echo ""
  echo "  example :"
  echo "    ./rebuild.sh -w ~ -u"

  exit 2
}

SHORT=w:,h,u,U
LONG=workspace:,help,swd-update,ubuntu-update
OPTS=$(getopt -a -n rebuild --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

workspace=""
swd_update=no
ubuntu_update=no

while :; do
  case "$1" in
  -w | --workspace)
    workspace="$2"
    shift 2
    ;;
  -h | --help)
    help
    ;;
  -u | --swd-update)
    swd_update=yes
    shift
    ;;
  -U | --ubuntu_update)
    ubuntu_update=yes
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Unexpected option: $1"
    help
    ;;
  esac
done

if [ -z "$workspace" ]; then
  help
fi

mkdir -p "$workspace"

# Stop docker
docker stop $NAME-$SUFFIX >/dev/null 2>&1
docker rm $NAME-$SUFFIX -f >/dev/null 2>&1

# User info
GID=$(id -g)
PWD=$USER
SUDO=yes

# Build docker
if [[ $ubuntu_update == yes ]]; then
  docker pull ubuntu:$UBUNTU || exit 1
fi

if [[ $swd_update == yes ]]; then
  swd_update=$(date '+%s')
fi

DOCKER_BUILDKIT=1 docker build --tag $NAME-$SUFFIX:$VERSION --rm \
    --build-arg NAME=$NAME-$SUFFIX --build-arg SWD_UPDATE=$swd_update \
    . &&
  # use the --shm-size 1g or firefox/chrome will crash
  # use --network=host for can0 access
  # use -v /dev:/dev -v /run/udev:/run/udev:ro for ttyUSBx access
  # use --restart=always to auto-start at system boot
  docker run --name $NAME-$SUFFIX --restart=always -dti --tmpfs /tmp --shm-size 1g --privileged -v /dev:/dev -v /run/udev:/run/udev:ro --cap-add=NET_ADMIN -w /home/$USER -v $workspace:/home/$USER --network=host $NAME-$SUFFIX:$VERSION $USER $PWD $SUDO $UID $GID || exit 1
echo ""
echo "Successfully created :"
echo " - image     : '$NAME-$SUFFIX:$VERSION'"
echo " - container : '$NAME-$SUFFIX' (user '$USER')"
echo ""
echo "To start/stop the container :"
echo " - docker start $NAME-$SUFFIX"
echo " - docker stop $NAME-$SUFFIX"
echo ""
echo "To stop all the containers :"
echo ' - docker stop $(docker ps -a -q)'
echo ""
echo "To show the container logs :"
echo " - docker logs -f $NAME-$SUFFIX"
echo ""
echo "To enter in the container :"
echo " - docker exec -u $USER -ti $NAME-$SUFFIX /bin/bash"
echo ' - xhost + && docker exec -u $USER -ti -e DISPLAY=${DISPLAY}' $NAME-$SUFFIX /bin/bash
