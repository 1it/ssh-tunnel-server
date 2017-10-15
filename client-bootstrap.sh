#!/usr/bin/env bash

# Bootstrap client-server
# For Debian 8+, Ubuntu 14.04+
# Use root or other fully privileged user account (with sudo)

# Variables
REMOTE_USER=robot

# Add user
useradd -c 'Robot client account' -m $REMOTE_USER

# Create ssh key (id_rsa)
if [ ! -f /home/$REMOTE_USER/.ssh/id_rsa ]; then
    sudo -u $REMOTE_USER ssh-keygen -q -t rsa -b 2048 -f /home/$REMOTE_USER/.ssh/id_rsa -P ""
    echo "Put the below key to the master server file: /home/$REMOTE_USER/.ssh/authorized_keys"
    cat /home/$REMOTE_USER/.ssh/id_rsa.pub
fi

# Copy ssh-tunnel script to robot home dir
if [ ! -f /home/$REMOTE_USER/ssh-tunnel ]; then
    cp ./ssh-tunnel /home/$REMOTE_USER/
    chmod +x /home/$REMOTE_USER/ssh-tunnel
fi

# Create cron-job
if [ -v SOURCE_PORTS ]; then
    echo -e "SOURCE_PORTS='$SOURCE_PORTS'" > /etc/cron.d/ssh-tunnel
fi

if [ -v REMOTE_HOST ]; then
    echo -e "REMOTE_HOST=$REMOTE_HOST\n" >> /etc/cron.d/ssh-tunnel
fi

if ! grep -q "$REMOTE_USER" /etc/cron.d/ssh-tunnel; then
    echo -e "*/5 * * * * $REMOTE_USER /home/$REMOTE_USER/ssh-tunnel start\n" >> /etc/cron.d/ssh-tunnel
fi

echo "All set!"
