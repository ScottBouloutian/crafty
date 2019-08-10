#!/usr/bin/env bash

# Install msm
yum update -y
git clone git@github.com:ScottBouloutian/thecraftmine.git /tmp
wget -q http://git.io/lu0ULA -O /tmp/msm
bash /tmp/msm

# Create msm user and configure msm folder permissions
useradd minecraft
chmod -R 777 /opt/msm
usermod --home /opt/msm minecraft
chown minecraft:minecraft /opt/msm
chmod u+rwx /opt/msm

# Create a new server
cp /tmp/thecraftmine/msm/msm.conf /etc
msm update --noinput
msm server create thecraftmine
msm jargroup create minecraft minecraft
msm thecraftmine jar minecraft
cp /tmp/thecraftmine/msm/server.properties /opt/msm/servers/thecraftmine
cp /tmp/thecraftmine/msm/eula.txt /opt/msm/servers/thecraftmine
cp /tmp/thecraftmine/msm/white-list.txt /opt/msm/servers/thecraftmine

# Install forge
if [ ! -d "/opt/msm/jars/forge" ]; then
    msm jargroup create forge https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.jar
    msm jargroup getlatest forge
    wget https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.zip -O /tmp/forge.zip
    unzip /tmp/forge.zip -d /opt/msm/jars/forge
else
    msm jargroup changeurl forge https://s3.amazonaws.com/scottbouloutian-dev/cdn/forge-1.13.2-25.0.102.jar
fi
chown -R minecraft:minecraft /opt/msm/jars/forge
chmod -R u+rwx /opt/msm/jars/forge

# Install mods
mkdir -p /opt/msm/servers/thecraftmine/plugins
wget https://dev.bukkit.org/projects/essentials/files/latest -O /opt/msm/servers/thecraftmine/plugins
wget https://scottbouloutian-dev.s3.amazonaws.com/cdn/thecraftmine-datapacks.zip -O /tmp/datapacks.zip
unzip /tmp/datapacks.zip -d /opt/msm/servers/thecraftmine/datapacks

# Store the world folders in RAM for a performance boost
mkdir /dev/shm/msm
chown minecraft:minecraft /dev/shm/msm
chmod -R 775 /dev/shm/msm

# Start the services
cp /tmp/thecraftmine/msm/msm /etc/cron.d
service cron restart
msm thecraftmine start
