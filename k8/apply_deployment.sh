#!/bin/sh
# File: k8/apply_deployment.sh
CURRENT_DIR="`dirname "$0"`"
kubectl apply -f "${CURRENT_DIR}/deployment.yml"
