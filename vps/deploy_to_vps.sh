#!/bin/bash
# "fynapp_gitops/vps/deploy_to_vps.sh"
#
CURRENT_DIR="`dirname "$0"`"
cd "${CURRENT_DIR}" ;

# Set app version if 1st parameter is passed to this script
if [ "$1" != "" ]; then
    echo $1 > version.txt
fi

VPS_USER="ocrusr"
if [ "$2" != "" ]; then
    VPS_USER=$2
fi

VPS_NAME="vps.fynapp.com"
if [ "$3" != "" ]; then
    VPS_NAME=$3
fi

VPS_PORT="22"
if [ "$4" != "" ]; then
    VPS_PORT=$4
fi

LOCAL_PRIVATE_KEY_PATH="~/.ssh/id_rsa_${VPS_USER}_${VPS_NAME}"
if [ "$5" != "" ]; then
    LOCAL_PRIVATE_KEY_PATH=$5
fi

VPS_DIRECTORY="~/fynapp_start"
if [ "$6" != "" ]; then
    VPS_DIRECTORY=$6
fi

# Variables
SSH_CMD="ssh -p ${VPS_PORT} -i ${LOCAL_PRIVATE_KEY_PATH}"

# Generate .env
if [ -f "${CURRENT_DIR}/../k8/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/../k8/.env" ; set +o allexport ;
fi

echo "" > .env
echo "FYNAPP_REACT_APP_API_URL=${FYNAPP_BACKEND_PUBLIC_URL}:${FYNAPP_BACKEND_PORT}" >> .env;
echo "FYNAPP_DB_URI=${FYNAPP_DB_URI}" >> .env;
echo "FYNAPP_SECRET_KEY=${FYNAPP_SECRET_KEY}" >> .env;

# Copy minimum files to bring up the containers
rsync -arv -e "${SSH_CMD}" ./.env ${VPS_USER}@${VPS_NAME}:${VPS_DIRECTORY}/
rsync -arv -e "${SSH_CMD}" ./* ${VPS_USER}@${VPS_NAME}:${VPS_DIRECTORY}/

# Restart the containers on thee VPS
${SSH_CMD} ${VPS_USER}@${VPS_NAME} "sh -x ${VPS_DIRECTORY}/run-server-containers.sh down"
${SSH_CMD} ${VPS_USER}@${VPS_NAME} "sh -x ${VPS_DIRECTORY}/run-server-containers.sh"
