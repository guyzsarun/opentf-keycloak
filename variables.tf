variable "clients" {
  type = list(object({
    client_id           = string
    valid_redirect_uris = list(string)
    client_secret       = string
    base_url            = string
    name                = string
  }))
}

variable "user" {
  type = list(object({
    username = string
    email    = string
    password = string
  }))
}

variable "root_group" {
  type = list(string)
}

variable "viewer_group" {
  type = list(string)
}

variable "keycloak_configuration" {
  type = object({
    client_id = string
    username  = string
    password  = string
    url       = string
  })
}