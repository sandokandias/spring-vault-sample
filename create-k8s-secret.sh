#!/usr/bin/env bash

echo "Creating k8s vault secret..."
k3s kubectl apply -f  vault/vault-ksa.yml
