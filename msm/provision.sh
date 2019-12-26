#!/usr/bin/env bash

sudo cp /tmp/msm.conf /etc
sudo cp /tmp/.bashrc /opt/msm
sudo su minecraft
cd /opt/msm

# Create a new server
msm update --noinput
msm server create thecraftmine
msm jargroup create minecraft minecraft
msm jargroup create minecraft-snapshot minecraft-snapshot
msm thecraftmine jar minecraft
cp /tmp/server.properties /opt/msm/servers/thecraftmine
cp /tmp/eula.txt /opt/msm/servers/thecraftmine
cp /tmp/white-list.txt /opt/msm/servers/thecraftmine
mkdir /dev/shm/msm

# Install mods
mkdir -p /opt/msm/servers/thecraftmine/plugins
wget https://dev.bukkit.org/projects/worldedit/files/latest -O /opt/msm/servers/thecraftmine/plugins

# Start the services
msm thecraftmine start
