#!/usr/bin/env bash

export PATH=$PATH:/usr/local/bin

# Create a new server
msm update --noinput
msm server create thecraftmine
msm jargroup create minecraft minecraft
msm thecraftmine jar minecraft
cp /tmp/thecraftmine-master/msm/server.properties /opt/msm/servers/thecraftmine
cp /tmp/thecraftmine-master/msm/eula.txt /opt/msm/servers/thecraftmine
cp /tmp/thecraftmine-master/msm/white-list.txt /opt/msm/servers/thecraftmine
mkdir /dev/shm/msm

# Install forge
if [ ! -d "/opt/msm/jars/forge" ]; then
    msm jargroup create forge https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.jar
    msm jargroup getlatest forge
    wget https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.zip -O /tmp/forge.zip
    unzip /tmp/forge.zip -d /opt/msm/jars/forge
else
    msm jargroup changeurl forge https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.jar
fi

# Install mods
mkdir -p /opt/msm/servers/thecraftmine/plugins
wget https://dev.bukkit.org/projects/essentials/files/latest -O /opt/msm/servers/thecraftmine/plugins
wget https://scottbouloutian-dev.s3.amazonaws.com/cdn/thecraftmine-datapacks.zip -O /tmp/datapacks.zip
unzip /tmp/datapacks.zip -d /opt/msm/servers/thecraftmine/datapacks

# Start the services
msm thecraftmine start
