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

role_response=$(./target/vault read -format=json auth/approle/role/sample/role-id)
echo "role_response $role_response"
role_id=$(echo $role_response | ./jq -j '.data.role_id')
echo "role_id: $role_id"
export VAULT_APP_ROLE_ROLE_ID=$role_id

secret_response=$(./target/vault write -force -format=json auth/approle/role/sample/secret-id)
echo "secret_response: $secret_response"
secret_id=$(echo $secret_response | ./jq -j '.data.secret_id')
echo "secret_id: $secret_id"
export VAULT_APP_ROLE_SECRET_ID=$secret_id

unset VAULT_TOKEN

mvn spring-boot:run
