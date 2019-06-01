#!/usr/bin/env bash

echo "Creating k8s vault secret..."
k3s kubectl apply -f  vault/vault-ksa.yml

k8s_vault_token=$(k3s kubectl get secret | grep vault | awk '{print $1}')

mkdir -p /tmp/vault-k8s

SA_JWT_TOKEN=$(k3s kubectl get secret $k8s_vault_token -o jsonpath="{.data.token}" | base64 --decode; echo)
echo $SA_JWT_TOKEN > /tmp/vault-k8s/sa_jwt_token;

SA_CA_CRT=$(k3s kubectl get secret $k8s_vault_token -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
echo $SA_CA_CRT > /tmp/vault-k8s/sa_ca_crt;
