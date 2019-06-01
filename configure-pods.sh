#!/usr/bin/env bash
echo "Configuring vault POD..."

k3s kubectl delete configmap vault
k3s kubectl delete service vault
k3s kubectl delete service spring-vault-sample
k3s kubectl delete deployment vault
k3s kubectl delete deployment spring-vault-sample

k3s kubectl create configmap vault --from-file=vault/config.hcl
k3s kubectl apply -f  vault/service.yml
k3s kubectl apply -f  vault/deployment.yml

k3s kubectl get all | grep vault
sleep 5
k3s kubectl get all | grep vault

pod=$(k3s kubectl get pods | grep vault | awk '{print $1}')
k3s kubectl port-forward $pod 8200:8200 >/dev/null 2>&1 < /dev/null &

SA_JWT_TOKEN=$(cat /tmp/vault-k8s/sa_jwt_token)
SA_CA_CRT=$(cat /tmp/vault-k8s/sa_ca_crt)

export VAULT_TOKEN="87e7784b-d598-44fe-8962-c7c345a11eed"
export VAULT_ADDR="http://0.0.0.0:8200"

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
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_ca_cert="$SA_CA_CRT"
./target/vault write auth/kubernetes/role/vault \
    bound_service_account_names=vault-auth \
    bound_service_account_namespaces=default \
    policies=default,sample \
    ttl=10m

echo "Configuring app POD..."

k3s kubectl apply -f service.yml
k3s kubectl apply -f deployment.yml
k3s kubectl get all | grep vault
sleep 5
k3s kubectl get all | grep vault
