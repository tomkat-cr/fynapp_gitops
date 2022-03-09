#!/bin/sh
# File: k8/delete_deployment.sh
CURRENT_DIR="`dirname "$0"`"
kubectl delete -f "${CURRENT_DIR}/deployment.yml"
