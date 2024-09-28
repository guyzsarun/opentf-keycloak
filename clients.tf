resource "keycloak_openid_client" "clients" {
  realm_id      = keycloak_realm.realm.id
  client_id     = each.value.client_id
  client_secret = each.value.client_secret

  for_each = { for i in var.clients : i.client_id => i }

  name    = each.value.name
  enabled = true

  access_type = "CONFIDENTIAL"

  standard_flow_enabled = true
  implicit_flow_enabled = true

  login_theme                  = "keycloak"
  direct_access_grants_enabled = true
  valid_redirect_uris          = each.value.valid_redirect_uris
  base_url                     = each.value.base_url
}

resource "keycloak_role" "argo_admin" {
  realm_id    = keycloak_realm.realm.id
  name        = "argoCDAdmins"
  description = "ArgoCD admin role"
  client_id   = keycloak_openid_client.clients["argo-openid-client"].id
  attributes = {
    managed_by = "opentofu"
  }
}


resource "keycloak_role" "minio_admin" {
  realm_id    = keycloak_realm.realm.id
  name        = "consoleAdmin"
  description = "Minio admin role"
  client_id   = keycloak_openid_client.clients["minio-openid-client"].id
  attributes = {
    managed_by = "opentofu"
  }
}

resource "keycloak_role" "minio_user" {
  realm_id    = keycloak_realm.realm.id
  name        = "readonly"
  description = "Minio readonly role"
  client_id   = keycloak_openid_client.clients["minio-openid-client"].id
  attributes = {
    managed_by = "opentofu"
  }
}
