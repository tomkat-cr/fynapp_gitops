#!/bin/sh
# File: k8/forward_app_ports.sh
# 2022-02-26 | CR
CURRENT_DIR="`dirname "$0"`"
. ${CURRENT_DIR}/get_defaults.sh
kubectl port-forward --address 0.0.0.0 service/fynappfront ${FYNAPP_FRONTEND_PORT}:3001 &
kubectl port-forward --address 0.0.0.0 service/fynappback ${FYNAPP_BACKEND_PORT}:5000 &
