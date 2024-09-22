resource "keycloak_realm" "realm" {
  realm        = "keycloak-oidc"
  enabled      = true
  display_name = "keycloak-oidc"

  login_theme = "keycloak"

  access_code_lifespan = "1h"

  attributes = {
    managed_by = "opentofu"
  }
}