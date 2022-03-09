#!/bin/sh
# File: k8/get_defaults.sh
# 2022-02-26 | CR
#
CURRENT_DIR="`dirname "$0"`";
if [ -f "${CURRENT_DIR}/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/.env" ; set +o allexport ;
fi
if [ "${FYNAPP_FRONTEND_PUBLIC_URL}" == "" ]; then
    export FYNAPP_FRONTEND_PUBLIC_URL="http://desar.fynapp.com";
fi
if [ "${FYNAPP_BACKEND_PUBLIC_URL}" == "" ]; then
    export FYNAPP_BACKEND_PUBLIC_URL="http://desar.fynapp.com";
fi
if [ "${FYNAPP_FRONTEND_PORT}" == "" ]; then
    export FYNAPP_FRONTEND_PORT="3001";
fi
if [ "${FYNAPP_BACKEND_PORT}" == "" ]; then
    export FYNAPP_BACKEND_PORT="5000";
fi
