#!/bin/bash

add_user() {
    if [[ $# -eq 0 ]]; then
        echo "No input parameters. exiting..."
        echo "There should be 3 input parameters at least: user/pwd/sudo/[uid/gid]"
        exit
    fi

    if [[ $# -lt 3 ]]; then
        echo "Incorrect input. exiting..."
        echo "There should be 3 input parameters at least: user/pwd/sudo/[uid/gid]"
        exit
    fi

    if [[ $# -gt 5 ]]; then
        echo "Incorrect input. exiting..."
        echo "There should be 5 input parameters: user/pwd/sudo/[uid/gid]"
        exit
    fi

    if [ -z "$gid" ]; then
        addgroup $user
    else
        addgroup $user --gid=$gid
    fi

    if [ -z "$gid" ]; then
        useradd -m -s /bin/bash -g $user $user
    else
        useradd -m -s /bin/bash --uid=$uid -g $user $user
    fi
    wait

    echo $user:$pwd | chpasswd
    wait

    if [[ $sudo == "yes" ]]; then
        usermod -aG sudo $user
    fi
    wait

    usermod -aG dialout $user
    usermod -aG messagebus $user
    wait

    echo "User '$user' is added"
}

echo "Entrypoint script is running..."
echo

rm -f /.docker_ready

user=$1
pwd=$2
sudo=$3
uid=$4
gid=$5

# Create user
echo -e "Create user $user...\n"
add_user $user $pwd $sudo $uid $gid
grep -F "export USER_NAME=" /.dockername || echo "export USER_NAME=$user" >> /.dockername

# Create dbus session file
echo -e "Create dbus session file...\n"
su $user --command "/usr/bin/dbus-launch > /tmp/SYSTEMCTL_dbus.id"

# Set xfce4 terminal encoding to UTF-8
rcdir="/home/$user/.config/xfce4/terminal/terminalrc"
rc="$rcdir/terminalrc"
su $user --command "mkdir -p $rcdir; touch $rc; sed -i '/^$/d' $rc; sed -i '/Encoding=.*/d' $rc; echo -e 'Encoding=UTF-8\n' >> $rc"

# Remove xfce4 panel2
rc="/home/$user/.config/xfce4/panel"
su $user --command "rm -rf $rc/launcher-*"

# Load docker env variables
source /.dockername

# Set docker environment variable
su $user --command 'grep -F "source /opt/ezw/install/setup.bash" ~/.bashrc || echo -e "\n# Set docker environment\n# Comment out the line below to disable docker environment\n[ -s /.dockername ] && source /opt/ezw/install/setup.bash\n" >> ~/.bashrc'
su $user --command 'source ~/.bashrc'

# Install .desktop files
su $user --command "mkdir -p ~/Desktop && cp /opt/ezw/install/${DOCKER_NAME}-terminal.desktop ~/Desktop"

# Replace user name into some config files
sed -i "s/swd_sk/$user/" /etc/supervisor/conf.d/ezw-swd.conf
sed -i "s/swd_sk/$user/" /home/$user/Desktop/${DOCKER_NAME}-terminal.desktop

# Create var/www/html symlink
rm -rf /var/www/html
ln -s /opt/ezw/html /var/www

# Test colcon build
if [ ! -d $home/ros-humble_ws/install ]; then
  source /opt/install/ros-humble/setup.bash
  cd $home/ros-humble_ws/
  colcon build
fi

# Create docker ready flag
touch /.docker_ready

# Start supervisor
echo -e "Start supervisor services...\n"
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
