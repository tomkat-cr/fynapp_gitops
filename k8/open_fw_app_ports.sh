#!/bin/sh
# File: k8/open_fw_app_ports.sh
# 2022-02-25 | CR
#
# Open up port 3001 [FE] on the firewall (one time only)
# Open up port 5000 [BE] on the firewall (one time only)
CURRENT_DIR="`dirname "$0"`"
. ${CURRENT_DIR}/get_defaults.sh
sudo firewall-cmd --zone=public --add-port=${FYNAPP_FRONTEND_PORT}/tcp --permanent
sudo firewall-cmd --zone=public --add-port=${FYNAPP_BACKEND_PORT}/tcp --permanent
# Reload firewall
sudo firewall-cmd --reload
