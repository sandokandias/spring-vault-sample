#!/usr/bin/env bash

echo "Removing pods..."

k3s kubectl delete configmap vault
k3s kubectl delete service vault
k3s kubectl delete deployment vault
k3s kubectl delete service spring-vault-sample
k3s kubectl delete deployment spring-vault-sample
