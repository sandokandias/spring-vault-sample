# Manage tokens
path "auth/token/*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}

path "auth/approle/login" {
  capabilities = [ "create", "read" ]
}

path "auth/approle/role/sample/role-id" {
  capabilities = [ "read" ]
}

path "auth/approle/role/sample/secret-id" {
  capabilities = ["create", "read", "update"]
}

path "secret/bootstrap" {
  capabilities = ["read"]
}

path "secret/bootstrap/vault-approle" {
  capabilities = ["read"]
}

path "secret/application" {
  capabilities = ["read"]
}

path "secret/application/vault-approle" {
  capabilities = ["read"]
}

path "app/secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "app/warmup/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
