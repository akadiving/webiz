variable "ec_instance" {
  description = "Information about EC2 instances"
  type        = any
  default     = {}
}

variable "secrets" {
  default = {}
  type = any
  description = "values for secrets"
}