#!/bin/sh
# File: k8/apply_secrets.sh
# 2022-02-25 | CR
#
# Ref:
# https://kubernetes.io/docs/tasks/inject-data-application/_print/
#
SECRET_GROUP="fynappsecrets"
CURRENT_DIR="`dirname "$0"`"
GENERATE_SECRETS=1
if [ ! -f "${CURRENT_DIR}/.env" ]; then
    echo "Error [1]: Please define the .env file with the secrets, file: '${CURRENT_DIR}/.env'";
    GENERATE_SECRETS=0;
else
    . ${CURRENT_DIR}/get_defaults.sh
    if [ "${FYNAPP_DB_URI}" == "" ]; then
        echo "Error [2]: Missing FYNAPP_DB_URI variable...";
        GENERATE_SECRETS=0;
    fi
    if [ "${FYNAPP_SECRET_KEY}" == "" ]; then
        echo "Error [3]: Missing FYNAPP_SECRET_KEY variable...";
        GENERATE_SECRETS=0;
    fi
fi
if [ ${GENERATE_SECRETS} -eq 1 ]; then
    kubectl delete secret generic ${SECRET_GROUP}
    kubectl create secret generic ${SECRET_GROUP} \
        --from-literal="fynapp_backend_public_url=${FYNAPP_BACKEND_PUBLIC_URL}:${FYNAPP_BACKEND_PORT}" \
        --from-literal="fynapp_db_uri=${FYNAPP_DB_URI}" \
        --from-literal="fynapp_secret_key=${FYNAPP_SECRET_KEY}"
    if [ $? -eq 0 ]; then
      echo "Secrets were created for '${SECRET_GROUP}' -> $?";
    else
      echo "Error [5]: Could not create the secrets for '${SECRET_GROUP}'";
    fi
else
    echo "Error [4]: Could not create the secrets for '${SECRET_GROUP}'";
fi
