resource "keycloak_group" "root" {
  realm_id = keycloak_realm.realm.id
  name     = "root"
}


resource "keycloak_group" "viewer" {
  realm_id = keycloak_realm.realm.id
  name     = "viewer"
}

resource "keycloak_group_roles" "root" {
  realm_id = keycloak_realm.realm.id
  group_id = keycloak_group.root.id

  role_ids = [
    keycloak_role.minio_admin.id,
    keycloak_role.argo_admin.id,
  ]
}

resource "keycloak_group_roles" "viewer" {
  realm_id = keycloak_realm.realm.id
  group_id = keycloak_group.viewer.id

  role_ids = [
    keycloak_role.minio_user.id,
  ]
}