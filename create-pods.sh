#!/usr/bin/env bash

echo "Getting vault token and ca..."
k8s_vault_token=$(k3s kubectl get secret | grep vault | awk '{print $1}')

SA_JWT_TOKEN=$(k3s kubectl get secret $k8s_vault_token -o jsonpath="{.data.token}" | base64 --decode; echo)
echo $SA_JWT_TOKEN

SA_CA_CRT=$(k3s kubectl get secret $k8s_vault_token -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
echo $SA_CA_CRT

echo "Creating vault pod..."

k3s kubectl create configmap vault --from-file=vault/config.hcl
k3s kubectl apply -f  vault/service.yml
k3s kubectl apply -f  vault/deployment.yml

k3s kubectl get all | grep vault
echo "Sleeping for 10 seconds until pod is running..."
sleep 10
k3s kubectl get all | grep vault

echo "Configuring k8s authentication on vault..."

pod=$(k3s kubectl get pods | grep vault | awk '{print $1}')
k3s kubectl port-forward $pod 8200:8200 >/dev/null 2>&1 < /dev/null &

export VAULT_TOKEN="87e7784b-d598-44fe-8962-c7c345a11eed"
export VAULT_ADDR="http://0.0.0.0:8200"

rm -rf ./target/vault
unzip vault_0.8.3_linux_amd64.zip -d ./target/

./target/vault mount -path=app/warmup generic
./target/vault mount -path=app/secret generic

./target/vault policy-write sample k8s-policy.hcl

./target/vault auth-enable kubernetes
./target/vault write auth/kubernetes/config \
    kubernetes_host=https://kubernetes \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_ca_cert="$SA_CA_CRT"
./target/vault write auth/kubernetes/role/sample \
    bound_service_account_names=vault-auth \
    bound_service_account_namespaces=default \
    policies=default,sample \
    ttl=2m

echo "Creating spring boot app pod..."
k3s kubectl apply -f service.yml
k3s kubectl apply -f deployment.yml
k3s kubectl get all | grep vault
