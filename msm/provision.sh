#!/usr/bin/env bash

cd /opt/msm
cp /tmp/.bashrc .
source .bashrc

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
wget https://scottbouloutian-dev.s3.amazonaws.com/cdn/worldedit-bukkit-7.0.1.jar -O /opt/msm/servers/thecraftmine/plugins/worldedit-bukkit-7.0.1.jar

# Start the services
msm thecraftmine start
