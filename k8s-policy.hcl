# Manage tokens
path "auth/token/*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}

path "secret/bootstrap" {
  capabilities = ["read"]
}

path "secret/bootstrap/vault-k8s" {
  capabilities = ["read"]
}

path "secret/application" {
  capabilities = ["read"]
}

path "secret/application/vault-k8s" {
  capabilities = ["read"]
}

path "app/secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "app/warmup/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
