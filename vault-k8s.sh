#!/usr/bin/env bash
echo "Exporting vault vars..."
export VAULT_TOKEN="87e7784b-d598-44fe-8962-c7c345a11eed"
export VAULT_ADDR="http://0.0.0.0:8200"

echo "Installing vault cli 0.8.3..."
rm -rf ./target/vault
unzip vault_0.8.3_linux_amd64.zip -d ./target/

./target/vault mount -path=app/warmup generic
./target/vault mount -path=app/secret generic

./target/vault policy-write sample app-policy.hcl

./target/vault auth-enable approle
./target/vault write auth/approle/role/sample policies=sample period=2m

./target/vault auth-enable kubernetes
./target/vault write auth/kubernetes/config \
    kubernetes_host=https://192.168.0.22:8443 \
    kubernetes_ca_cert=@ca.crt
./target/vault write auth/kubernetes/role/vault \
    bound_service_account_names=vault-auth \
    bound_service_account_namespaces=default \
    policies=default,sample \
    ttl=10m