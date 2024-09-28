resource "keycloak_openid_client_scope" "client_scope" {
  realm_id               = keycloak_realm.realm.id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
  gui_order              = 1
}

resource "keycloak_openid_client_default_scopes" "default_scopes" {
  realm_id = keycloak_realm.realm.id

  for_each  = { for i in keycloak_openid_client.clients : i.client_id => i }
  client_id = each.value.id

  default_scopes = [
    "profile",
    "email",
    "roles",
    "web-origins",
    keycloak_openid_client_scope.client_scope.name,
  ]
}

resource "keycloak_generic_protocol_mapper" "minio_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_scope_id = keycloak_openid_client_scope.client_scope.id
  name            = "minio-mapper"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-client-role-mapper"
  config = {
    "claim.name"                           = "policy"
    "access.token.claim"                   = "true"
    "id.token.claim"                       = "true"
    "userinfo.token.claim"                 = "true"
    "multivalued"                          = "true"
    "usermodel.clientRoleMapping.clientId" = keycloak_openid_client.clients["minio-openid-client"].client_id
  }
}

resource "keycloak_generic_protocol_mapper" "harbor_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_scope_id = keycloak_openid_client_scope.client_scope.id
  name            = "harbor-mapper"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-group-membership-mapper"
  config = {
    "claim.name"           = "groups"
    "access.token.claim"   = "true"
    "id.token.claim"       = "true"
    "userinfo.token.claim" = "true"
    "multivalued"          = "true"
  }
}

resource "keycloak_generic_protocol_mapper" "argocd_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_scope_id = keycloak_openid_client_scope.client_scope.id
  name            = "argo-mapper"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-client-role-mapper"
  config = {
    "claim.name"                           = "groups"
    "access.token.claim"                   = "true"
    "id.token.claim"                       = "true"
    "userinfo.token.claim"                 = "true"
    "multivalued"                          = "true"
    "usermodel.clientRoleMapping.clientId" = keycloak_openid_client.clients["argo-openid-client"].client_id
  }
}
