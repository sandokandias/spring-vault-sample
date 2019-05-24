# Manage tokens
path "auth/token/*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}

# Write ACL policies
path "sys/policies/acl/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
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

# Manage secret engine - for Verification test
path "app/secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "app/warmup/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
