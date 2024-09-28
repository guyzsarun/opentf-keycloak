resource "keycloak_user" "user" {
  realm_id = keycloak_realm.realm.id
  username = each.value.username
  email    = each.value.email
  enabled  = true

  for_each = { for i in var.user : i.username => i }

  initial_password {
    value     = each.value.password
    temporary = false
  }
}

resource "keycloak_user_groups" "root_groups" {
  realm_id = keycloak_realm.realm.id
  user_id  = keycloak_user.user[each.value].id

  for_each = toset(var.root_group)

  group_ids = [
    keycloak_group.root.id
  ]
}

resource "keycloak_user_groups" "viewer_groups" {
  realm_id = keycloak_realm.realm.id
  user_id  = keycloak_user.user[each.value].id

  for_each = toset(var.viewer_group)

  group_ids = [
    keycloak_group.viewer.id
  ]
}
