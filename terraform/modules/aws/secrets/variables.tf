variable "secrets" {
  type = map(object({
    name = string
  }))
  description = "Information about secrets"
}