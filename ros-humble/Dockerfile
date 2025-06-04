FROM ubuntu:22.04

ARG NAME=ros-humble
ARG TARGETPLATFORM
ARG ROS_DISTRO=humble
ARG INSTALL_PACKAGE=desktop
ARG ROS_DOMAIN_ID=40

RUN echo "I'm building for $TARGETPLATFORM"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update --fix-missing
RUN apt-get -y upgrade

RUN apt-get install -y wget curl git build-essential vim-tiny sudo lsb-release locales bash-completion tzdata gosu gnupg2 can-utils iproute2 iputils-ping htop python3-pip net-tools minicom nano

RUN echo "deb http://packages.ez-wheel.com:8081/ubuntu/ $(lsb_release -cs) main" >> /etc/apt/sources.list && \
    wget -qO - http://packages.ez-wheel.com:8081/archive.key | gpg --dearmor > /etc/apt/trusted.gpg.d/ez-wheel-keyring.gpg


# RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
#     echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
#     curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && \
    apt-get install -y ros-${ROS_DISTRO}-${INSTALL_PACKAGE} \
    python3-rosdep \
    # python3-rosinstall \
    python3-rosinstall-generator \
    python3-colcon-common-extensions
    # python3-wstool

RUN apt-get install -y \
    ros-${ROS_DISTRO}-urg-node \
    ros-${ROS_DISTRO}-xacro \
    # ros-${ROS_DISTRO}-hector-slam \
    # ros-${ROS_DISTRO}-iris-lama \
    ros-${ROS_DISTRO}-teleop-twist-joy \
    # ros-${ROS_DISTRO}-tf2-web-republisher \
    ros-${ROS_DISTRO}-laser-filters \
    # ros-${ROS_DISTRO}-sick-safetyscanners \
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-robot-state-publisher

RUN rosdep init

RUN apt-get install -y \
    xfce4 \
    xfce4-clipman-plugin \
    xfce4-cpugraph-plugin \
    xfce4-netload-plugin \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-terminal \
    xfce4-xkb-plugin

# RUN apt-get install -y \
#     xorgxrdp \
#     xrdp

RUN apt remove -y light-locker xscreensaver

RUN apt-get install -y \
    fonts-noto-color-emoji \
    terminator

# BEGIN dev #####
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    pkg-config \
    doxygen graphviz \
    libcurl4-openssl-dev \
    # clang-format-11 \
    # clang-tidy-12 \
    inotify-tools \
    openjdk-8-jdk \
    openjdk-11-jdk

RUN apt-get update && apt-get install -y \
    patchelf \
    dpkg-dev \
    debhelper \
    python3-bloom \
    fakeroot \
    dh-make \
    devscripts

RUN apt-get install python3-requests

RUN pip install \
    csv_diff \
    black \
    jsonref

RUN ln -s /usr/bin/clang-format-11 /usr/bin/clang-format

RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-*/jre/bin/java

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && \
    chmod a+rx /usr/bin/repo && \
    ln -s /usr/bin/python3 /usr/bin/python
# END dev #####

# RUN pip install --upgrade --break-system-packages pip
RUN pip install --no-cache-dir attrs click netifaces colorama 
# Note: we had to merge the two "pip install" package lists here, otherwise
# the last "pip install" command in the OP may break dependency resolution…

RUN apt-get install -y nginx

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#RUN apt autoremove -y && rm -rf /var/cache/apt /var/lib/apt/lists
RUN apt autoremove -y

# Set SWD_UPDATE to re-run the following layers
ARG SWD_UPDATE=no

RUN apt-get update --fix-missing && apt-get install -y \
    swd-services \
    swd-system-config-2wheels \
    ros-${ROS_DISTRO}-swd-ros2-controllers
    # ros-${ROS_DISTRO}-swd-ros-controllers \
    # ros-${ROS_DISTRO}-swd-robot-manager

# Overwrite some SWD config files
COPY ./config/opt/ezw /opt/ezw

ADD ./conf.d /etc/supervisor/conf.d

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN echo "export DOCKER_NAME=${NAME}" > /.dockername
RUN echo "export ROS_DISTRO=${ROS_DISTRO}" >> /.dockername
RUN echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}" >> /.dockername

# Docker config
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
