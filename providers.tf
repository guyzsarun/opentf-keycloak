terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
    }
  }
}

provider "keycloak" {
  client_id = var.keycloak_configuration.client_id
  username  = var.keycloak_configuration.username
  password  = var.keycloak_configuration.password
  url       = var.keycloak_configuration.url
}