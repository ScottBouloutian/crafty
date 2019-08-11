#!/usr/bin/env bash

# Install msm
UPDATE_URL="https://raw.githubusercontent.com/msmhq/msm/master"
wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/msmcommon.sh
source /tmp/msmcommon.sh

function update_system_packages() {
    install_log "Updating sources"
    sudo yum update -y --skip-broken || install_error "Couldn't update packages"
}

function install_dependencies() {
    install_log "Installing required packages"
    sudo yum install -y screen rsync zip java jq || install_error "Couldn't install dependencies"
}

function enable_init() {
    install_log "Enabling automatic startup and shutdown"
    sudo chkconfig --add msm
}

function config_installation() {
    msm_user_system=true
}

install_msm

# Provision msm
wget https://github.com/ScottBouloutian/thecraftmine/archive/master.zip -O /tmp/master.zip
unzip /tmp/master.zip -d /tmp
sudo cp /tmp/thecraftmine-master/msm/msm.conf /etc
sudo cp /tmp/thecraftmine-master/msm/msm /etc/cron.d
chmod +x /tmp/thecraftmine-master/msm/provision.sh
sudo su -c /tmp/thecraftmine-master/msm/provision.sh minecraft
sudo service crond restart
