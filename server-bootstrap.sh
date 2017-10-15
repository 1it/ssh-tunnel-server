#!/usr/bin/env bash

# Bootstrap ssh-server
# For Debian 8+, Ubuntu 14.04+
# Use root or other fully privileged user account (with sudo)

# Variables
REMOTE_USER=robot

# Check GatewayPorts option exists
if ! grep 'GatewayPorts yes' /etc/ssh/sshd_config; then
    echo '# For tunnels' >> /etc/ssh/sshd_config
    echo 'GatewayPorts yes' >> /etc/ssh/sshd_config
    service ssh reload
fi

# Add user
useradd -c 'Robots master account' -m $REMOTE_USER

# Check .ssh dir
if [ ! -d /home/$REMOTE_USER/.ssh/ ]; then
    mkdir -p /home/$REMOTE_USER/.ssh
fi

# Check authorized_keys
if [ ! -f /home/$REMOTE_USER/.ssh/authorized_keys ]; then
    touch /home/$REMOTE_USER/.ssh/authorized_keys
    chmod 0600 /home/$REMOTE_USER/.ssh/authorized_keys
    chown $REMOTE_USER: /home/$REMOTE_USER/.ssh/authorized_keys
fi

echo 'All set!'
