#!/usr/bin/env bash

echo "Removing k8s vault secret..."

secret=$(k3s kubectl get secret | grep vault | awk '{print $1}')
k3s kubectl delete secret $secret