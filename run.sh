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

token_response=$(./target/vault token-create -policy=sample -ttl=1m -use-limit=2 -format=json)
echo "token_response: $token_response"
token=$(echo $token_response | ./jq -j '.auth.client_token')
echo "token: $token"

export VAULT_TOKEN=$token

mvn spring-boot:run
