#!/bin/bash
# scripts/k8_start_minikube.sh
# 2022-02-25 | CR
service docker start
# Para poder acceder desde afuera del server (inseguro, sin filtro)
kubectl proxy --address='0.0.0.0' --disable-filter=true &
# Inicia Minikube / K8
minikube start &
# Para habilitar el Dashboard de K8
minikube dashboard &
# Para habilitar el Service
minikube tunnel &
